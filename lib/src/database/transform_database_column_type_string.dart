part of 'transform_database_column_type.dart';

abstract class TransformDatabaseColumnTypeString extends TransformDatabaseColumnType {
  TransformDatabaseColumnTypeString();

  @override
  dynamic convertValue(dynamic value) => StringUtil.decodeNotNull(value, '');

  @override
  String sqlDefaultValue(TransformDatabaseType databaseType, dynamic defaultValue) {
    if (defaultValue == null) return "''";
    return "'${defaultValue.toString()}'";
  }
}

/// unlimited length
class TransformDatabaseColumnText extends TransformDatabaseColumnTypeString {
  TransformDatabaseColumnText();

  @override
  String asSql(TransformDatabaseType databaseType) {
    switch (databaseType) {
      case TransformDatabaseType.postgres:
        return "text";
      case TransformDatabaseType.mysql:
        return "text";
    }
  }
}

/// fixed length
class TransformDatabaseColumnVarchar extends TransformDatabaseColumnTypeString {
  final int length;
  TransformDatabaseColumnVarchar({required this.length}) {
    assert(length > 0);
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    switch (databaseType) {
      case TransformDatabaseType.postgres:
        return "varchar($length)";
      case TransformDatabaseType.mysql:
        return "varchar($length)";
    }
  }
}

/// 1 byte
class TransformDatabaseColumnChar extends TransformDatabaseColumnVarchar {
  TransformDatabaseColumnChar() : super(length: 1);
}

/// UUID (36 bytes)
class TransformDatabaseColumnUUID extends TransformDatabaseColumnVarchar {
  TransformDatabaseColumnUUID() : super(length: 36);

  @override
  bool isAutoGenerated() => true;
}
