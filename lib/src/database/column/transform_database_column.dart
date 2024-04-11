import '../../../transform.dart';

class TransformDatabaseColumn {
  final String name;
  final TransformDatabaseColumnType type;
  final bool isNullable;
  final dynamic defaultValue;
  final bool isPrimaryKey;
  final bool isUnique;

  TransformDatabaseColumn({
    required this.name,
    required this.type,
    this.isNullable = false,
    this.defaultValue,
    this.isPrimaryKey = false,
    this.isUnique = false,
  }) {
    assert(name.isNotEmpty);
  }

  String asSql(TransformDatabaseClass database) {
    return "$name ${type.asSql(database)} ${isNullable ? 'null' : 'not null'} ${defaultValue != null ? 'default ${_defaultValueSql(database)}' : ''}";
  }

  String _defaultValueSql(TransformDatabaseClass database) {
    if (defaultValue == null) return '';
    if (defaultValue is String) return "'$defaultValue'";
    if (defaultValue is bool) return defaultValue ? 'true' : 'false';
    return defaultValue.toString();
  }
}
