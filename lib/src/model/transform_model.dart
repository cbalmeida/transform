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

    for (TransformModelColumn column in columns) {
      if (columns.any((c) => c != column && c.name == column.name)) {
        throw Exception("Duplicated column name: ${column.name}");
      }
    }

    for (TransformModelIndex index in indexes) {
      if (indexes.any((i) => i != index && i.name == index.name)) {
        throw Exception("Duplicated index name: ${index.name}");
      }
      for (String columnName in index.columnNames) {
        assert(columns.any((column) => column.name == columnName));
      }
    }
  }

  TransformDatabaseTable get databaseTable => TransformDatabaseTable(
        name: name,
        schema: schema,
        columns: columns.map((e) => e.databaseColumn).toList(),
        indexes: indexes.map((e) => e.databaseIndex).toList(),
      );
}
