import '../../transform.dart';

part 'transform_model_column_type_num.dart';
part 'transform_model_column_type_string.dart';

enum TransformModelColumnTypeValueType { string, int, double }

abstract class TransformModelColumnType {
  TransformDatabaseColumnType get databaseColumnType;

  TransformModelColumnTypeValueType get valueType;
}
