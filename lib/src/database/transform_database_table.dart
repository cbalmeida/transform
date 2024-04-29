import '../../transform.dart';

class TransformDatabaseTable {
  final String name;
  final String schema;
  final List<TransformDatabaseColumn> columns;
  final List<TransformDatabaseIndex> indexes;
  final List<TransformMapped> initialData;

  TransformDatabaseTable({
    required this.name,
    required this.schema,
    required this.columns,
    required this.indexes,
    required this.initialData,
  }) {
    _assertConstructor();
  }

  _assertConstructor() {
    assert(name.isNotEmpty);
    assert(schema.isNotEmpty);
    assert(columns.isNotEmpty);
    assert(primaryKeyColumns.isNotEmpty);

    for (TransformDatabaseColumn column in columns) {
      if (columns.any((c) => c != column && c.name == column.name)) {
        throw Exception("Duplicated column name: ${column.name}");
      }
    }

    for (TransformDatabaseIndex index in indexes) {
      if (indexes.any((i) => i != index && i.name == index.name)) {
        throw Exception("Duplicated index name: ${index.name}");
      }
      for (String columnName in index.columnNames) {
        assert(columns.any((column) => column.name == columnName));
      }
    }
  }

  String get sql => schema.isNotEmpty ? "$schema.$name" : name;

  List<TransformDatabaseColumn> get primaryKeyColumns => columns.where((element) => element.isPrimaryKey).toList();

  TransformDatabaseColumn columnByName(String name) => columns.firstWhere((element) => element.name.toLowerCase() == name.toLowerCase());

  List<TransformDatabaseQueryBuilderCondition> primaryKeyConditions(Map<String, dynamic> primaryKeyValues) {
    List<TransformDatabaseQueryBuilderCondition> conditions = [];
    for (TransformDatabaseColumn column in primaryKeyColumns) {
      if (!primaryKeyValues.containsKey(column.name)) {
        throw Exception("Invalid primary key values! Expected key: ${column.name}");
      }
      conditions.add(TransformDatabaseQueryBuilderCondition.equals(column, column.convertValue(primaryKeyValues[column.name])));
    }
    return conditions;
  }

  Future<TransformEither<Exception, bool>> exists(TransformDatabaseSession session) => session.tableExists(this);

  Future<TransformEither<Exception, bool>> create(TransformDatabaseSession session) => session.createTable(this);
}
