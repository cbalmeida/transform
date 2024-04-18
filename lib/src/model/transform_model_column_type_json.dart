part of 'transform_model_column_type.dart';

class TransformModelColumnTypeJson extends TransformModelColumnType {
  TransformModelColumnTypeJson();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeJson();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.json;
}
