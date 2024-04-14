import 'package:transform/transform.dart';

class DatabasePostgres extends TransformDatabasePostgres {
  DatabasePostgres({
    required super.host,
    required super.port,
    required super.database,
    required super.username,
    required super.password,
    required super.sslMode,
  });

  factory DatabasePostgres.teste() {
    return DatabasePostgres(
      host: 'localhost',
      port: 5432,
      database: 'postgres',
      username: 'postgres',
      password: 'postgres',
      sslMode: TransformDatabasePostgresSslMode.disable,
    );
  }
}
