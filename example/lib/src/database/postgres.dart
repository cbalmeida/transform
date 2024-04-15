import 'package:transform/transform.dart';

class DatabasePostgres extends TransformDatabasePostgres {
  DatabasePostgres();

  @override
  Future<TransformDatabasePostgresParams> get params async => TransformDatabasePostgresParams.fromMap({
        'POSTGRES_HOST': 'aws-0-us-west-1.pooler.supabase.com',
        'POSTGRES_PORT': 5432,
        'POSTGRES_DATABASE': 'postgres',
        'POSTGRES_USERNAME': 'postgres.wqbjdbwdmghzwngibibv',
        'POSTGRES_PASSWORD': 'K0VbcXgi5CLXlv44',
        'POSTGRES_SSL_MODE': 'disable',
      });
}
