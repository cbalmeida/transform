import '../../transform.dart';

abstract class TransformModel {
  String get name;
  String get schema;
  List<TransformModelColumn> get columns;
  List<TransformModelIndex> get indexes;

  TransformModel() {
    _assertConstructor();
  }

  _assertConstructor() {
    assert(name.isNotEmpty);
    assert(schema.isNotEmpty);
    assert(columns.isNotEmpty);

    Map<String, TransformModelColumn> columnsMap = {};
    for (TransformModelColumn column in columns) {
      if (columnsMap.containsKey(column.name)) {
        throw Exception("Duplicated column name: ${column.name}");
      }
      columnsMap[column.name] = column;
    }

    Map<String, TransformModelIndex> indexesMap = {};
    for (TransformModelIndex index in indexes) {
      if (indexesMap.containsKey(index.name)) {
        throw Exception("Duplicated index name: ${index.name}");
      }
      indexesMap[index.name] = index;
    }
  }

  TransformDatabaseTable get databaseTable => TransformDatabaseTable(
        name: name,
        schema: schema,
        columns: columns.map((e) => e.databaseColumn).toList(),
        indexes: indexes.map((e) => e.databaseIndex).toList(),
      );

  List<TransformModelColumn> get primaryKeyColumns => columns.where((element) => element.isPrimaryKey).toList();

  TransformDatabaseColumn columnByName(String name) {
    for (TransformModelColumn column in columns) {
      if (column.name.toLowerCase() == name.toLowerCase()) return column.databaseColumn;
    }
    throw Exception("Column not found: $name");
  }
}
