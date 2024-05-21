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

  @override
  String toString() => name;

  String asSql(TransformDatabaseType databaseType) {
    String type = this.type.asSql(databaseType);
    String nullable = isNullable ? 'null' : 'not null';
    String defaultValue = this.defaultValue != null ? 'default ${sqlDefaultValue(databaseType)}' : '';
    return "$name $type $nullable $defaultValue";
  }

  String asSqlNullable(TransformDatabaseType databaseType) {
    String type = this.type.asSql(databaseType);
    return "$name $type null ";
  }

  String sqlDefaultValue(TransformDatabaseType databaseType) => type.sqlDefaultValue(databaseType, defaultValue);

  dynamic convertValue(dynamic value) => type.convertValue(value);

  TransformDatabaseQueryBuilderCondition equals(dynamic value) => TransformDatabaseQueryBuilderCondition.equals(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition notEquals(dynamic value) => TransformDatabaseQueryBuilderCondition.notEquals(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition inValues(dynamic value) => TransformDatabaseQueryBuilderCondition.inValues(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition notInValues(dynamic value) => TransformDatabaseQueryBuilderCondition.notInValues(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition lowerThan(dynamic value) => TransformDatabaseQueryBuilderCondition.lowerThan(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition lowerOrEqualsThan(dynamic value) => TransformDatabaseQueryBuilderCondition.lowerOrEqualsThan(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition biggerThan(dynamic value) => TransformDatabaseQueryBuilderCondition.biggerThan(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition biggerOrEqualsThan(dynamic value) => TransformDatabaseQueryBuilderCondition.biggerOrEqualsThan(this, convertValue(value));
  TransformDatabaseQueryBuilderCondition exists(dynamic value) => TransformDatabaseQueryBuilderCondition.exists(this, convertValue(value));
}
