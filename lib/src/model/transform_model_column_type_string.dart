part of 'transform_model_column_type.dart';

class TransformModelColumnTypeText extends TransformModelColumnType {
  TransformModelColumnTypeText();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnText();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.string;
}

class TransformModelColumnTypeVarchar extends TransformModelColumnType {
  final int length;
  TransformModelColumnTypeVarchar({required this.length}) {
    assert(length > 0);
  }

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnVarchar(length: length);

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.string;
}

class TransformModelColumnTypeChar extends TransformModelColumnType {
  TransformModelColumnTypeChar();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnChar();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.string;
}

class TransformModelColumnTypeUUID extends TransformModelColumnType {
  TransformModelColumnTypeUUID();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnUUID();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.string;
}
