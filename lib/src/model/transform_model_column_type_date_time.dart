part of 'transform_model_column_type.dart';

class TransformModelColumnTypeTimeStamp extends TransformModelColumnType {
  TransformModelColumnTypeTimeStamp();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTimeStamp();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.dateTime;
}

class TransformModelColumnTypeDate extends TransformModelColumnType {
  TransformModelColumnTypeDate();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnDate();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.dateTime;
}

class TransformModelColumnTypeTime extends TransformModelColumnType {
  TransformModelColumnTypeTime();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTime();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.dateTime;
}
