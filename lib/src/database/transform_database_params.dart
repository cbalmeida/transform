import 'package:transform/src/database/transform_database.dart';

abstract class TransformDatabaseParams {
  final TransformDatabaseType type;
  const TransformDatabaseParams({required this.type});

  static TransformDatabaseParamsBuilderPostgres postgres = TransformDatabaseParamsBuilderPostgres();
}
