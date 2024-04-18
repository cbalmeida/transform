part of 'transform_model_column_type.dart';

/// 1 byte
class TransformModelColumnTypeBool extends TransformModelColumnType {
  TransformModelColumnTypeBool();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeBool();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.bool;
}

/// 2 bytes	(-32768 to +32767)
class TransformModelColumnTypeSmallInt extends TransformModelColumnType {
  TransformModelColumnTypeSmallInt();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeSmallInt();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.int;
}

/// 4 bytes	(-2147483648 to +2147483647)
class TransformModelColumnTypeInteger extends TransformModelColumnType {
  TransformModelColumnTypeInteger();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeInteger();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.int;
}

/// 8 bytes	(-9223372036854775808 to +9223372036854775807)
class TransformModelColumnTypeBigInt extends TransformModelColumnType {
  TransformModelColumnTypeBigInt();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeBigInt();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.int;
}

/// 2 bytes	(1 to +32767)
class TransformModelColumnTypeSmallSerial extends TransformModelColumnType {
  TransformModelColumnTypeSmallSerial();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeSmallSerial();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.int;
}

/// 4 bytes	(1 to +2147483647)
class TransformModelColumnTypeSerial extends TransformModelColumnType {
  TransformModelColumnTypeSerial();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeSerial();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.int;
}

/// 8 bytes	(1 to +9223372036854775807)
class TransformModelColumnTypeBigSerial extends TransformModelColumnType {
  TransformModelColumnTypeBigSerial();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeBigSerial();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.int;
}

/// variable bytes (depends of precision)
class TransformModelColumnTypeDecimal extends TransformModelColumnType {
  final int precision;
  final int scale;
  TransformModelColumnTypeDecimal({this.precision = 20, this.scale = 6}) {
    assert(precision > 0);
    assert(scale >= 0);
    assert(scale <= precision);
  }

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeDecimal(precision: precision, scale: scale);

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.double;
}

/// variable bytes (precision: 20, scale: 2)
class TransformModelColumnTypeMonetary extends TransformModelColumnType {
  TransformModelColumnTypeMonetary();

  @override
  TransformDatabaseColumnType get databaseColumnType => TransformDatabaseColumnTypeMonetary();

  @override
  TransformModelColumnTypeValueType get valueType => TransformModelColumnTypeValueType.double;
}
