part of 'transform_database_column_type.dart';

abstract class TransformDatabaseColumnTypeString extends TransformDatabaseColumnType {
  TransformDatabaseColumnTypeString();
}

/// unlimited length
class TransformDatabaseColumnText extends TransformDatabaseColumnTypeString {
  TransformDatabaseColumnText();

  @override
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "text";
      case TransformDatabaseClassType.mysql:
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
  String asSql(TransformDatabaseClass database) {
    switch (database.type) {
      case TransformDatabaseClassType.postgres:
        return "varchar($length)";
      case TransformDatabaseClassType.mysql:
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
}
