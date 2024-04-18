part of 'transform_database_column_type.dart';

/// variable bytes
class TransformDatabaseColumnTypeJson extends TransformDatabaseColumnType {
  TransformDatabaseColumnTypeJson();

  @override
  dynamic convertValue(dynamic value) => jsonEncode(JsonUtil.decodeNotNull(value, {}));

  @override
  String sqlDefaultValue(TransformDatabaseType databaseType, dynamic defaultValue) {
    if (defaultValue == null) return "'{}'";
    return "'${jsonEncode(defaultValue)}'";
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    switch (databaseType) {
      case TransformDatabaseType.postgres:
        return "jsonb";
      case TransformDatabaseType.mysql:
        return "json";
    }
  }
}
