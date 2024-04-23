import '../../transform.dart';

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
    _assertConstructor();
  }

  _assertConstructor() {
    assert(name.isNotEmpty);
    if (isPrimaryKey) assert(!isNullable);
    if (isUnique) assert(!isNullable);
  }

  String asSql(TransformDatabaseType databaseType) {
    return "$name ${type.asSql(databaseType)} ${isNullable ? 'null' : 'not null'} ${defaultValue != null ? 'default ${sqlDefaultValue(databaseType)}' : ''}";
  }

  String asSqlNullable(TransformDatabaseType databaseType) {
    return "$name ${type.asSql(databaseType)} null ";
  }

  String sqlDefaultValue(TransformDatabaseType databaseType) => type.sqlDefaultValue(databaseType, defaultValue);

  dynamic convertValue(dynamic value) => type.convertValue(value);
}
