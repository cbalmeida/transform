part of '../transform_database.dart';

enum TransformDatabasePostgresSslMode { disable, require, verifyFull }

class TransformDatabaseParamsPostgres extends TransformDatabaseParams {
  final String host;
  final int port;
  final String database;
  final String? username;
  final String? password;
  final TransformDatabasePostgresSslMode? sslMode;

  TransformDatabaseParamsPostgres({required this.host, required this.port, required this.database, required this.username, required this.password, required this.sslMode}) : super(type: TransformDatabaseType.postgres);

  postgres.SslMode get postgresSslMode {
    switch (sslMode) {
      case TransformDatabasePostgresSslMode.disable:
        return postgres.SslMode.disable;
      case TransformDatabasePostgresSslMode.require:
        return postgres.SslMode.require;
      case TransformDatabasePostgresSslMode.verifyFull:
        return postgres.SslMode.verifyFull;
      case null:
        return postgres.SslMode.disable;
    }
  }
}

class TransformDatabaseSessionPostgres extends TransformDatabaseSession {
  final postgres.TxSession _session;

  TransformDatabaseSessionPostgres(this._session);

  @override
  TransformDatabaseType get databaseType => TransformDatabaseType.postgres;

  @override
  bool get isOpen => _session.isOpen;

  @override
  Future<void> get closed => _session.closed;

  @override
  Future<void> rollback() => _session.rollback();

  @override
  Future<TransformEither<Exception, bool>> checkDatabaseConnection() async {
    try {
      String query = "select 1 as result";
      final result = await executeRawQuery(query);
      return result.fold((l) => Left(l), (r) => Right(true));
    } on Exception catch (e) {
      return Left(Exception("Error executing checkDatabaseConnection\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, int>> tableCount(TransformDatabaseTable table) async {
    try {
      String query = "select count(*) as count from ${table.schema}.${table.name} ";
      Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name};
      final result = await executeRawQuery(query, parameters: parameters);
      return result.fold((l) => Left(l), (r) => Right(r.first["count"] as int));
    } on Exception catch (e) {
      return Left(Exception("Error executing tableExists: ${table.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, bool>> tableHasRows(TransformDatabaseTable table) async {
    try {
      String query = "select 1 from ${table.schema}.${table.name} limit 1";
      Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name};
      TransformEither<Exception, List<Map<String, dynamic>>> result = await executeRawQuery(query, parameters: parameters);
      return result.fold((l) => Left(l), (r) => Right(r.isNotEmpty));
    } on Exception catch (e) {
      return Left(Exception("Error executing tableExists: ${table.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, bool>> tableExists(TransformDatabaseTable table) async {
    try {
      String query = "select table_name from information_schema.tables where table_schema = lower(@schema_name) and table_name = lower(@table_name) limit 1";
      Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name};
      TransformEither<Exception, List<Map<String, dynamic>>> result = await executeRawQuery(query, parameters: parameters);
      return result.fold((l) => Left(l), (r) => Right(r.isNotEmpty));
    } on Exception catch (e) {
      return Left(Exception("Error executing tableExists: ${table.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, bool>> primaryKeyExists(TransformDatabaseTable table) async {
    try {
      String query = "select constraint_name from information_schema.table_constraints where table_schema = lower(@schema_name) and table_name = lower(@table_name) and constraint_type = 'PRIMARY KEY' limit 1";
      Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name};
      TransformEither<Exception, List<Map<String, dynamic>>> result = await executeRawQuery(query, parameters: parameters);
      return result.fold((l) => Left(l), (r) => Right(r.isNotEmpty));
    } on Exception catch (e) {
      return Left(Exception("Error executing primaryKeyExists: ${table.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, bool>> columnExists(TransformDatabaseTable table, TransformDatabaseColumn column) async {
    try {
      String query = "select column_name from information_schema.columns where table_schema = lower(@schema_name) and table_name = lower(@table_name) and column_name = lower(@column_name) limit 1";
      Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name, "column_name": column.name};
      TransformEither<Exception, List<Map<String, dynamic>>> result = await executeRawQuery(query, parameters: parameters);
      return result.fold((l) => Left(l), (r) => Right(r.isNotEmpty));
    } on Exception catch (e) {
      return Left(Exception("Error executing columnExists: ${table.name}.${column.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, bool>> createTable(TransformDatabaseTable table) async {
    try {
      // table
      String query = "create table if not exists ${table.schema}.${table.name}  (";
      query += table.columns.first.asSql(databaseType);
      query += ")";
      final resultExecute = await executeRawQuery(query);
      if (resultExecute.isLeft) throw resultExecute.left;

      // columns
      for (int i = 1; i < table.columns.length; i++) {
        final resultExecute = await createColumn(table, table.columns[i]);
        if (resultExecute.isLeft) throw resultExecute.left;
      }

      // primary key
      String primaryKeyColumns = table.columns.where((column) => column.isPrimaryKey).map((column) => column.name).join(", ");
      if (primaryKeyColumns.isNotEmpty) {
        final resultPrimaryKeyExists = await primaryKeyExists(table);
        if (resultPrimaryKeyExists.isLeft) throw resultPrimaryKeyExists.left;
        if (resultPrimaryKeyExists.right == false) {
          query = "alter table ${table.schema}.${table.name} add primary key ($primaryKeyColumns)";
          final resultExecute = await executeRawQuery(query);
          if (resultExecute.isLeft) throw resultExecute.left;
        }
      }

      // indexes
      for (TransformDatabaseIndex index in table.indexes) {
        String indexColumns = index.columnNames.join(", ");
        query = "create ${index.isUnique ? "unique" : ""} index if not exists ${index.name} on ${table.schema}.${table.name} ($indexColumns)";
        final resultExecute = await executeRawQuery(query);
        if (resultExecute.isLeft) throw resultExecute.left;
      }

      // initial data
      if (table.initialData.isNotEmpty) {
        for (TransformMapped mapped in table.initialData) {
          final result = await table.insert.values(mapped).onConflictDoNothing().execute(this);
          if (result.isLeft) throw result.left;
        }
      }

      return Right(true);
    } on Exception catch (e) {
      return Left(Exception("Error executing createTable: ${table.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, bool>> createColumn(TransformDatabaseTable table, TransformDatabaseColumn column) async {
    try {
      var resultColumnExists = await columnExists(table, column);
      if (resultColumnExists.isLeft) throw resultColumnExists.left;
      if (resultColumnExists.right) return Right(true);

      if (column.isNullable == true) {
        String query = "alter table ${table.schema}.${table.name} add column if not exists ${column.asSql(databaseType)}";
        final resultExecute = await executeRawQuery(query);
        if (resultExecute.isLeft) throw resultExecute.left;
        return Right(true);
      }

      String defaultValue = column.sqlDefaultValue(databaseType);
      String asSqlNullable = column.asSqlNullable(databaseType);

      String query = "alter table ${table.schema}.${table.name} add column if not exists $asSqlNullable";
      var resultExecute = await executeRawQuery(query);
      if (resultExecute.isLeft) throw resultExecute.left;

      query = "update ${table.schema}.${table.name} set ${column.name} = $defaultValue";
      resultExecute = await executeRawQuery(query);
      if (resultExecute.isLeft) throw resultExecute.left;

      query = "alter table ${table.schema}.${table.name} alter column ${column.name} set not null";
      resultExecute = await executeRawQuery(query);
      if (resultExecute.isLeft) throw resultExecute.left;

      if (defaultValue != null) {
        query = "alter table ${table.schema}.${table.name} alter column ${column.name} set default $defaultValue";
        resultExecute = await executeRawQuery(query);
        if (resultExecute.isLeft) throw resultExecute.left;
      }

      return Right(true);
    } on Exception catch (e) {
      return Left(Exception("Error executing createColumn: ${table.name}.${column.name}\n$e"));
    }
  }

  @override
  Future<TransformEither<Exception, List<Map<String, dynamic>>>> executeRawQuery(String query, {Map<String, dynamic>? parameters}) async {
    try {
      final result = await _session.execute(postgres.Sql.named(query), parameters: parameters);
      List<Map<String, dynamic>> list = result.map((row) => row.toColumnMap()).toList();
      return Right(list);
    } on Exception catch (e) {
      print(e.toString());
      return Left(Exception("Error executing query:\n$query\n$e"));
    }
  }
}

class TransformDatabasePostgres extends TransformDatabase {
  final TransformDatabaseParamsPostgres params;

  TransformDatabasePostgres({required this.params});

  postgres.Endpoint? _endPoint;
  postgres.Endpoint get endPoint => _endPoint ??= postgres.Endpoint(host: params.host, port: params.port, database: params.database, username: params.username, password: params.password);

  postgres.ConnectionSettings? _connectionSettings;
  postgres.ConnectionSettings get connectionSettings => _connectionSettings ??= postgres.ConnectionSettings(sslMode: params.postgresSslMode);

  //postgres.Connection? _connection;
  //Future<postgres.Connection> connection() async => _connection ??= await postgres.Connection.open(endPoint, settings: connectionSettings);
  Future<postgres.Connection> connection() async => postgres.Connection.open(endPoint, settings: connectionSettings);

  @override
  TransformDatabaseType get type => TransformDatabaseType.postgres;

  @override
  Future<TransformEither<E, R>> transaction<E extends Exception, R>(Future<TransformEither<E, R>> Function(TransformDatabaseSessionPostgres session) body) async {
    try {
      final conn = await connection();
      final TransformEither<E, R> result = await conn.runTx<TransformEither<E, R>>((tx) async {
        final session = TransformDatabaseSessionPostgres(tx);
        return body(session);
      });
      conn.close();
      return result;
    } on Exception catch (e) {
      return Left(e as E);
    }
  }
}

class TransformDatabaseParamsBuilderPostgres {
  TransformDatabaseParams fromMap(Map<String, dynamic> map) {
    String host = map.valueStringNotNull('POSTGRES_HOST', defaultValue: 'localhost');
    int port = map.valueIntNotNull('POSTGRES_PORT', defaultValue: 5432);
    String database = map.valueStringNotNull('POSTGRES_DATABASE', defaultValue: 'public');
    String username = map.valueStringNotNull('POSTGRES_USERNAME', defaultValue: 'postgres');
    String password = map.valueStringNotNull('POSTGRES_PASSWORD', defaultValue: 'postgres');
    TransformDatabasePostgresSslMode? sslMode;
    String sslModeString = map.valueStringNotNull('POSTGRES_SSL_MODE', defaultValue: 'disable');
    switch (sslModeString) {
      case 'disable':
        sslMode = TransformDatabasePostgresSslMode.disable;
      case 'require':
        sslMode = TransformDatabasePostgresSslMode.require;
      case 'verify-full':
        sslMode = TransformDatabasePostgresSslMode.verifyFull;
      default:
        sslMode = null;
    }
    return TransformDatabaseParamsPostgres(
      host: host,
      port: port,
      database: database,
      username: username,
      password: password,
      sslMode: sslMode,
    );
  }

  TransformDatabaseParams fromEnvironment() {
    String host = const String.fromEnvironment('POSTGRES_HOST', defaultValue: 'localhost');
    int port = const int.fromEnvironment('POSTGRES_PORT', defaultValue: 5432);
    String database = const String.fromEnvironment('POSTGRES_DATABASE', defaultValue: 'postgres');
    String username = const String.fromEnvironment('POSTGRES_USERNAME', defaultValue: 'postgres');
    String password = const String.fromEnvironment('POSTGRES_PASSWORD', defaultValue: 'postgres');
    TransformDatabasePostgresSslMode? sslMode;
    String sslModeString = String.fromEnvironment('POSTGRES_SSL_MODE', defaultValue: 'disable');
    switch (sslModeString) {
      case 'disable':
        sslMode = TransformDatabasePostgresSslMode.disable;
      case 'require':
        sslMode = TransformDatabasePostgresSslMode.require;
      case 'verify-full':
        sslMode = TransformDatabasePostgresSslMode.verifyFull;
      default:
        sslMode = null;
    }
    return TransformDatabaseParamsPostgres(
      host: host,
      port: port,
      database: database,
      username: username,
      password: password,
      sslMode: sslMode,
    );
  }

  TransformDatabaseParams fromVales({
    required String host,
    required int port,
    required String database,
    required String? username,
    required String? password,
    required TransformDatabasePostgresSslMode? sslMode,
  }) =>
      TransformDatabaseParamsPostgres(
        host: host,
        port: port,
        database: database,
        username: username,
        password: password,
        sslMode: sslMode,
      );
}
