import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  final TransformDatabaseClass dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.dataBase, required this.model, required this.adapter});

  Future<S?> findUnique({required Map<String, dynamic> where}) async {
    Map<String, dynamic>? result = await model.databaseTable.findUnique(dataBase, where: where);
    return result != null ? adapter.fromMap(result) : null;
  }

  Future<List<S>> findMany({required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) async {
    List<Map<String, dynamic>> result = await model.databaseTable.findMany(dataBase, where: where, orderBy: orderBy, limit: limit, offset: offset);
    return result.map((e) => adapter.fromMap(e)).toList();
  }
}

/*

findUnique()
findUniqueOrThrow()
findFirst()
findFirstOrThrow()
findMany()
create()
update()
upsert()
delete()
createMany()
updateMany()
deleteMany()
count()
aggregate()
groupBy()
*/
