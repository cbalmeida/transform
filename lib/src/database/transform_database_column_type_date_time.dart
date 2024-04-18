part of 'transform_database_column_type.dart';

abstract class TransformDatabaseColumnTypeDateTime extends TransformDatabaseColumnType {
  TransformDatabaseColumnTypeDateTime();

  @override
  dynamic convertValue(dynamic value) => DateTimeUtil.decodeNotNull(value, DateTime.fromMillisecondsSinceEpoch(0));

  @override
  String sqlDefaultValue(TransformDatabaseType databaseType, dynamic defaultValue) {
    if (defaultValue == null) {
      switch (databaseType) {
        case TransformDatabaseType.postgres:
          return "current_timestamp";
        case TransformDatabaseType.mysql:
          return "current_timestamp";
      }
    }
    return "'${defaultValue.toString()}'";
  }
}

/// 8 bytes
class TransformDatabaseColumnTimeStamp extends TransformDatabaseColumnTypeDateTime {
  TransformDatabaseColumnTimeStamp();

  @override
  String asSql(TransformDatabaseType databaseType) {
    switch (databaseType) {
      case TransformDatabaseType.postgres:
        return "timestamp";
      case TransformDatabaseType.mysql:
        return "timestamp";
    }
  }
}

/// 4 bytes
class TransformDatabaseColumnDate extends TransformDatabaseColumnTypeDateTime {
  TransformDatabaseColumnDate();

  @override
  String asSql(TransformDatabaseType databaseType) {
    switch (databaseType) {
      case TransformDatabaseType.postgres:
        return "date";
      case TransformDatabaseType.mysql:
        return "date";
    }
  }
}

/// 8 bytes
class TransformDatabaseColumnTime extends TransformDatabaseColumnTypeDateTime {
  TransformDatabaseColumnTime();

  @override
  String asSql(TransformDatabaseType databaseType) {
    switch (databaseType) {
      case TransformDatabaseType.postgres:
        return "time";
      case TransformDatabaseType.mysql:
        return "time";
    }
  }
}
