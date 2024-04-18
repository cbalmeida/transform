import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.dataBase, required this.model, required this.adapter}) {
    dataBase.registerTable(model.databaseTable);
  }

  Future<TransformEither<Exception, S?>> findUnique(TransformDatabaseSession session, {required Map<String, dynamic> where}) async {
    TransformEither<Exception, Map<String, dynamic>?> result = await model.databaseTable.findUnique(session, where: where);
    return result.fold((left) => Left(result.left), (right) => Right(result.right != null ? adapter.fromMap(result.right!) : null));
  }

  Future<TransformEither<Exception, List<S>>> findMany(TransformDatabaseSession session, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await model.databaseTable.findMany(session, where: where, orderBy: orderBy, limit: limit, offset: offset);
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
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
