import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.dataBase, required this.model, required this.adapter}) {
    dataBase.registerTable(model.databaseTable);
  }

  Future<TransformEither<Exception, S?>> findUnique({required Map<String, dynamic> where}) async {
    TransformEither<Exception, Map<String, dynamic>?> result = await model.databaseTable.findUnique(dataBase, where: where);
    return result.fold((left) => Left(result.left), (right) => Right(result.right != null ? adapter.fromMap(result.right!) : null));
  }

  Future<TransformEither<Exception, List<S>>> findMany({required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await model.databaseTable.findMany(dataBase, where: where, orderBy: orderBy, limit: limit, offset: offset);
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
