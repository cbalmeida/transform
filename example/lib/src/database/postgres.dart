import 'package:transform/transform.dart';

class DatabasePostgres extends TransformDatabasePostgres {
  DatabasePostgres() : super(params: TransformDatabasePostgresParams.fromEnvironment());
}
