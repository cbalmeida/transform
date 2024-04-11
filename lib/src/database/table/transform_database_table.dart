import '../../../transform.dart';

class TransformDatabaseTable {
  final String name;
  final String schema;
  final List<TransformDatabaseColumn> columns;

  TransformDatabaseTable({
    required this.name,
    required this.schema,
    required this.columns,
  });

  @override
  Future<bool> exists(TransformDatabaseClass database) => database.tableExists(this);

  Future<bool> create(TransformDatabaseClass database) => database.createTable(this);

  Future<Map<String, dynamic>?> findUnique(TransformDatabaseClass dataBase, {required Map<String, dynamic> where}) => dataBase.findUnique(this, where: where);

  Future<List<Map<String, dynamic>>> findMany(TransformDatabaseClass dataBase, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) => dataBase.findMany(this, where: where, orderBy: orderBy, limit: limit, offset: offset);
}
