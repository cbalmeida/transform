import '../../transform.dart';

part 'transform_model_column_type_date_time.dart';
part 'transform_model_column_type_json.dart';
part 'transform_model_column_type_num.dart';
part 'transform_model_column_type_string.dart';

enum TransformModelColumnTypeValueType { bool, string, int, double, dateTime, json }

abstract class TransformModelColumnType {
  TransformDatabaseColumnType get databaseColumnType;

  TransformModelColumnTypeValueType get valueType;
}
