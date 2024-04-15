import '../../transform.dart';

class TransformDatabaseTable {
  final String name;
  final String schema;
  final List<TransformDatabaseColumn> columns;
  final List<TransformDatabaseIndex> indexes;

  TransformDatabaseTable({
    required this.name,
    required this.schema,
    required this.columns,
    required this.indexes,
  }) {
    _assertConstructor();
  }

  _assertConstructor() {
    assert(name.isNotEmpty);
    assert(schema.isNotEmpty);
    assert(columns.isNotEmpty);

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

  Future<TransformEither<Exception, bool>> exists(TransformDatabase database) => database.tableExists(this);

  Future<TransformEither<Exception, bool>> create(TransformDatabase database) => database.createTable(this);

  Future<TransformEither<Exception, Map<String, dynamic>?>> findUnique(TransformDatabase dataBase, {required Map<String, dynamic> where}) => dataBase.findUnique(this, where: where);

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> findMany(TransformDatabase dataBase, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) => dataBase.findMany(this, where: where, orderBy: orderBy, limit: limit, offset: offset);
}
