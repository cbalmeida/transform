import 'package:transform/transform.dart';

class ServerParams {
  /// sets the web server parameters (required)
  static Future<TransformWebServerParams> get webServerParams async => TransformWebServerParams.fromValues(
        host: 'localhost',
        port: 8080,
      );

  /// sets the database parameters (the type used defines the database type to be used)
  static Future<TransformDatabaseParams> get databaseParams async => TransformDatabaseParams.postgres.fromVales(
        // Supabase
        host: 'aws-0-us-east-1.pooler.supabase.com',
        port: 5432,
        database: 'postgres',
        username: 'postgres.jowtsmjpicntbqdnawzy',
        password: 'b5q5JWvNEewDtR2I',
        sslMode: TransformDatabasePostgresSslMode.disable,
        /*
        // Local
        host: '192.168.0.11',
        port: 5432,
        database: 'afv',
        username: 'admin',
        password: 'admin',
        sslMode: TransformDatabasePostgresSslMode.disable,
         */
      );

  /// sets the jwt token parameters (the type used defines the encryption type to be used)
  static Future<TransformJWTParams> get jwtParams async => TransformJWTParams.rsaCert.fromFiles();

  static Future<TransformEmailSenderParams> get emailSenderParams async => TransformEmailSenderParams.gmail.fromVales(
        // GMAIL: setup a app password for the email account at: https://myaccount.google.com/apppasswords
        user: "transform.techalliances",
        password: "vlcq aksv egcn lvcw",
        senderEmail: "transform.techalliances@gmail.com",
        senderName: "Tech Alliances",
      );

  static Future<TransformRouteLimiterParams> get routeLimiterParams async => TransformRouteLimiterParams.fromValues(maxRequests: 10, timeFrameInSeconds: 5);
}
