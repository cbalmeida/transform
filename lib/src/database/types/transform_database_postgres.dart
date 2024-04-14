part of '../transform_database.dart';

enum TransformDatabasePostgresSslMode { disable, require, verifyFull }

class TransformDatabasePostgresParams {
  final String host;
  final int port;
  final String database;
  final String? username;
  final String? password;
  final TransformDatabasePostgresSslMode? sslMode;

  TransformDatabasePostgresParams({required this.host, required this.port, required this.database, required this.username, required this.password, required this.sslMode});

  factory TransformDatabasePostgresParams.fromEnvironment() {
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
    return TransformDatabasePostgresParams(
      host: host,
      port: port,
      database: database,
      username: username,
      password: password,
      sslMode: sslMode,
    );
  }

  factory TransformDatabasePostgresParams.fromMap(Map<String, dynamic> map) {
    String host = Util.stringFromMapNotNull(map, 'POSTGRES_HOST', 'localhost');
    int port = Util.intFromMapNotNull(map, 'POSTGRES_PORT', 5432);
    String database = Util.stringFromMapNotNull(map, 'POSTGRES_DATABASE', 'postgres');
    String username = Util.stringFromMapNotNull(map, 'POSTGRES_USERNAME', 'postgres');
    String password = Util.stringFromMapNotNull(map, 'POSTGRES_PASSWORD', 'postgres');
    TransformDatabasePostgresSslMode? sslMode;
    String sslModeString = Util.stringFromMapNotNull(map, 'POSTGRES_SSL_MODE', 'disable');
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
    return TransformDatabasePostgresParams(
      host: host,
      port: port,
      database: database,
      username: username,
      password: password,
      sslMode: sslMode,
    );
  }
}

class TransformDatabasePostgres extends TransformDatabase {
  final TransformDatabasePostgresParams params;
  TransformDatabasePostgres({required this.params});

  postgres.Endpoint? _endPoint;
  postgres.Endpoint get endPoint => _endPoint ??= postgres.Endpoint(host: params.host, port: params.port, database: params.database, username: params.username, password: params.password);

  postgres.SslMode get postgresSslMode => params.sslMode == TransformDatabasePostgresSslMode.disable
      ? postgres.SslMode.disable
      : params.sslMode == TransformDatabasePostgresSslMode.require
          ? postgres.SslMode.require
          : postgres.SslMode.verifyFull;

  postgres.ConnectionSettings? _connectionSettings;
  postgres.ConnectionSettings get connectionSettings => _connectionSettings ??= postgres.ConnectionSettings(sslMode: postgresSslMode);

  postgres.Connection? _connection;
  Future<postgres.Connection> connection() async => _connection ??= await postgres.Connection.open(endPoint, settings: connectionSettings);

  @override
  TransformDatabaseType get type => TransformDatabaseType.postgres;

  @override
  Future<List<Map<String, dynamic>>> execute(String query, {Map<String, dynamic>? parameters}) async {
    final conn = await connection();
    final result = await conn.execute(query, parameters: parameters);
    return result.map((row) => row.toColumnMap()).toList();
  }

  @override
  Future<bool> tableExists(TransformDatabaseTable table) async {
    String query = "select table_name from information_schema.tables where table_schema = lower(@schema_name) and table_name = lower(@table_name) limit 1";
    Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name};
    List<Map<String, dynamic>> result = await execute(query, parameters: parameters);
    return result.isNotEmpty;
  }

  @override
  Future<bool> columnExists(TransformDatabaseTable table, TransformDatabaseColumn column) async {
    String query = "select column_name from information_schema.columns where table_schema = lower(@schema_name) and table_name = lower(@table_name) and column_name = lower(@column_name) limit 1";
    Map<String, dynamic> parameters = {"schema_name": table.schema, "table_name": table.name, "column_name": column.name};
    List<Map<String, dynamic>> result = await execute(query, parameters: parameters);
    return result.isNotEmpty;
  }

  @override
  Future<bool> createTable(TransformDatabaseTable table) async {
    String query = "create table ${table.schema}.${table.name} if not exists (";
    query += table.columns.first.asSql(this);
    query += ")";
    await execute(query);

    // columns
    for (int i = 1; i < table.columns.length; i++) {
      query = "alter table ${table.schema}.${table.name} add column if not exists ${table.columns[i].asSql(this)}";
      await execute(query);
    }

    // primary key
    String primaryKeyColumns = table.columns.where((column) => column.isPrimaryKey).map((column) => column.name).join(", ");
    if (primaryKeyColumns.isNotEmpty) {
      query = "alter table ${table.schema}.${table.name} add primary key if not exists ($primaryKeyColumns)";
      await execute(query);
    }

    // indexes
    for (TransformDatabaseIndex index in table.indexes) {
      String indexColumns = index.columnNames.join(", ");
      query = "create ${index.isUnique ? "unique" : ""} index if not exists ${index.name} on ${table.schema}.${table.name} ($indexColumns)";
      await execute(query);
    }

    return true;
  }

  @override
  Future<Map<String, dynamic>?> findUnique(TransformDatabaseTable table, {required Map<String, dynamic> where}) async {
    String query = "";
    query += " select * ";
    query += "\n from ${table.schema}.${table.name} ";
    query += "\n where ";
    query += where.keys.map((key) => "($key = @${key}_value)").join(" and ");
    Map<String, dynamic> parameters = where.map((key, value) => MapEntry("${key}_value", value));
    query += "\n limit 1 ";
    List<Map<String, dynamic>> result = await execute(query, parameters: parameters);
    return result.isNotEmpty ? result.first : null;
  }

  @override
  Future<List<Map<String, dynamic>>> findMany(TransformDatabaseTable table, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) async {
    String query = "";
    query += " select * ";
    query += "\n from ${table.schema}.${table.name} ";
    query += "\n where ";
    query += where.keys.map((key) => "    ($key = @${key}_value) ").join("    and ");
    Map<String, dynamic> parameters = where.map((key, value) => MapEntry("${key}_value", value));
    if (orderBy != null) {
      query += "\n order by ";
      query += orderBy.keys.map((key) => "$key ${orderBy[key]} ").join(", ");
    }
    if (limit != null) {
      query += "\n limit $limit ";
    }
    if (offset != null) {
      query += "\n offset $offset ";
    }
    List<Map<String, dynamic>> result = await execute(query, parameters: parameters);
    return result;
  }
}
