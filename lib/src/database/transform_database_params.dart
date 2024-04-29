import 'package:transform/src/database/transform_database.dart';

abstract class TransformDatabaseParams {
  final TransformDatabaseType type;
  const TransformDatabaseParams({required this.type});

  static TransformDatabaseParamsBuilderPostgres postgres = TransformDatabaseParamsBuilderPostgres();
}

class TransformDatabaseParamsBuilderPostgres {
  TransformDatabaseParams fromMap(Map<String, dynamic> map) => TransformDatabaseParamsPostgres.fromMap(map);

  TransformDatabaseParams fromEnvironment() => TransformDatabaseParamsPostgres.fromEnvironment();

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
