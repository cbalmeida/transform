part of 'transform_database_column_type.dart';

abstract class TransformDatabaseColumnTypeNum extends TransformDatabaseColumnType {
  num get minValue;
  num get maxValue;
}

/// 2 bytes	(-32768 to +32767)
class TransformDatabaseColumnTypeSmallInt extends TransformDatabaseColumnTypeNum {
  TransformDatabaseColumnTypeSmallInt();

  @override
  num get minValue => -32768;

  @override
  num get maxValue => 32767;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "smallint";
      case TransformDatabaseClassType.mysql:
        return "smallint";
    }
  }
}

/// 4 bytes	(-2147483648 to +2147483647)
class TransformDatabaseColumnTypeInteger extends TransformDatabaseColumnTypeNum {
  TransformDatabaseColumnTypeInteger();

  @override
  num get minValue => -2147483647;

  @override
  num get maxValue => 2147483648;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "integer";
      case TransformDatabaseClassType.mysql:
        return "int";
    }
  }
}

/// 8 bytes	(-9223372036854775808 to +9223372036854775807)
class TransformDatabaseColumnTypeBigInt extends TransformDatabaseColumnTypeNum {
  TransformDatabaseColumnTypeBigInt();

  @override
  num get minValue => -9223372036854775808;

  @override
  num get maxValue => -9223372036854775807;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "bigint";
      case TransformDatabaseClassType.mysql:
        return "bigint";
    }
  }
}

/// 2 bytes	(1 to +32767)
class TransformDatabaseColumnTypeSmallSerial extends TransformDatabaseColumnTypeNum {
  TransformDatabaseColumnTypeSmallSerial();

  @override
  num get minValue => 1;

  @override
  num get maxValue => 32768;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "smallserial";
      case TransformDatabaseClassType.mysql:
        return "smallint unsigned not null auto_increment unique";
    }
  }
}

/// 4 bytes	(1 to +2147483647)
class TransformDatabaseColumnTypeSerial extends TransformDatabaseColumnTypeNum {
  TransformDatabaseColumnTypeSerial();

  @override
  num get minValue => 1;

  @override
  num get maxValue => 2147483647;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "serial";
      case TransformDatabaseClassType.mysql:
        return "int unsigned not null auto_increment unique";
    }
  }
}

/// 8 bytes	(1 to +9223372036854775807)
class TransformDatabaseColumnTypeBigSerial extends TransformDatabaseColumnTypeNum {
  TransformDatabaseColumnTypeBigSerial();

  @override
  num get minValue => 1;

  @override
  num get maxValue => 9223372036854775807;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "bigserial";
      case TransformDatabaseClassType.mysql:
        return "bigint unsigned not null auto_increment unique";
    }
  }
}

/// variable bytes (depends of precision)
class TransformDatabaseColumnTypeDecimal extends TransformDatabaseColumnTypeNum {
  final int precision;
  final int scale;
  TransformDatabaseColumnTypeDecimal({this.precision = 20, this.scale = 6}) {
    assert(precision > 0);
    assert(scale >= 0);
    assert(scale <= precision);
  }

  @override
  num get maxValue => 10 ^ precision - 10 ^ -scale;

  @override
  num get minValue => -10 ^ precision + 10 ^ -scale;

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "decimal($precision, $scale)";
      case TransformDatabaseClassType.mysql:
        return "decimal($precision, $scale)";
    }
  }
}

/// variable bytes (precision: 20, scale: 2)
class TransformDatabaseColumnTypeMonetary extends TransformDatabaseColumnTypeDecimal {
  TransformDatabaseColumnTypeMonetary() : super(precision: 20, scale: 2);
}
