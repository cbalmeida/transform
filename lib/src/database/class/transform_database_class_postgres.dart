part of 'transform_database_class.dart';

class TransformDatabasePostgres extends TransformDatabaseClass {
  final String host;
  final int port;
  final String database;
  final String? username;
  final String? password;
  final postgres.SslMode? sslMode;

  TransformDatabasePostgres({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
    this.sslMode = postgres.SslMode.disable,
  });

  postgres.Endpoint get endpoint => postgres.Endpoint(host: host, port: port, database: database, username: username, password: password);

  postgres.ConnectionSettings get connectionSettings => postgres.ConnectionSettings(sslMode: sslMode);

  postgres.Connection? _connection;

  Future<postgres.Connection> connection() async => _connection ??= await postgres.Connection.open(endpoint, settings: connectionSettings);

  List<Map<String, dynamic>> resultAsMap(postgres.Result result) => result.map((row) => row.toColumnMap()).toList();

  @override
  TransformDatabaseClassType get type => TransformDatabaseClassType.postgres;

  @override
  Future<List<Map<String, dynamic>>> execute(String query, {Map<String, dynamic>? parameters}) async {
    final conn = await connection();
    final result = await conn.execute(query, parameters: parameters);
    return resultAsMap(result);
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

    for (int i = 1; i < table.columns.length; i++) {
      query = "alter table ${table.schema}.${table.name} add column if not exists ${table.columns[i].asSql(this)}";
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
