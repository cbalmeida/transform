import 'package:transform/transform.dart';

class ServerParams {
  /// sets the web server parameters (required)
  static Future<TransformWebServerParams> get webServerParams async => TransformWebServerParams.fromValues(
        host: 'localhost',
        port: 8080,
      );

  /// sets the database parameters (the type used defines the database type to be used)
  static Future<TransformDatabaseParams> get databaseParams async => TransformDatabaseParams.postgres.fromVales(
        /*
        // Supabase
        host: 'aws-0-us-east-1.pooler.supabase.com',
        port: 5432,
        database: 'postgres',
        username: 'postgres.jowtsmjpicntbqdnawzy',
        password: 'b5q5JWvNEewDtR2I',
        sslMode: TransformDatabasePostgresSslMode.disable,
         */

        // Local
        host: '192.168.0.11',
        port: 5432,
        database: 'afv',
        username: 'admin',
        password: 'admin',
        sslMode: TransformDatabasePostgresSslMode.disable,
      );

  /// sets the jwt token parameters (the type used defines the encryption type to be used)
  static Future<TransformJWTParams> get jwtParams async => TransformJWTParams.rsaCert.fromFiles();
}
