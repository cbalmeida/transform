import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.dataBase, required this.model, required this.adapter}) {
    dataBase.registerTable(model.databaseTable);
  }

  List<S>? convertResultToList(List<Map<String, dynamic>> result) => result.map((e) => adapter.fromMap(e)).toList();

  S? convertResultToSingle(List<Map<String, dynamic>> result) => result.isNotEmpty ? adapter.fromMap(result.first) : null;

  TransformDatabaseQueryBuilderSelect selectQueryBuilder() => TransformDatabaseQueryBuilderSelect<List<S>>(convertResult: convertResultToList)..from(model.name);

  Future<TransformEither<Exception, S?>> selectObject(TransformDatabaseSession session, Map<String, dynamic> idValues) async {
    final builder = TransformDatabaseQueryBuilderSelect<S>(convertResult: convertResultToSingle);
    builder.from(model.name);
    List<TransformDatabaseQueryBuilderCondition> conditions = idValues.entries.map((e) => TransformDatabaseQueryBuilderCondition.equals(e.key, e.value)).toList();
    for (int i = 0; i < conditions.length; i++) {
      if (i == 0) {
        builder.where(conditions[i]);
      } else {
        builder.and(conditions[i]);
      }
    }
    List<TransformDatabaseQueryBuilderOrderBy> orderBy = idValues.keys.map((e) => TransformDatabaseQueryBuilderOrderBy.asc(e)).toList();
    builder.orderBy(orderBy);
    builder.limit(1);
    final result = await builder.execute(session);
    return result;
  }

/*
  Future<TransformEither<Exception, S?>> selectFirst(TransformDatabaseSession session, {TransformDatabaseWhere? where, List<String>? columns}) async {
    TransformEither<Exception, Map<String, dynamic>?> result = await session.selectFirst(model.databaseTable, where: where, columns: columns);
    return result.fold((left) => Left(result.left), (right) => Right(result.right != null ? adapter.fromMap(result.right!) : null));
  }

  Future<TransformEither<Exception, List<S>>> select(TransformDatabaseSession session, {TransformDatabaseWhere? where, List<String>? columns, List<String>? orderBy, int? limit, int? offset}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.select(model.databaseTable, where: where, columns: columns, orderBy: orderBy, limit: limit, offset: offset);
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
  }

  Future<TransformEither<Exception, int>> count(TransformDatabaseSession session, {TransformDatabaseWhere? where}) async {
    return await session.count(model.databaseTable, where: where);
  }
   */

  /*
  Future<TransformEither<Exception, S>> create(TransformDatabaseSession session, {required S object}) async {
    TransformEither<Exception, Map<String, dynamic>> result = await session.create(model.databaseTable, object: adapter.toMap(object));
    return result.fold((left) => Left(result.left), (right) => Right(adapter.fromMap(result.right)));
  }

  Future<TransformEither<Exception, List<S>>> createMany(TransformDatabaseSession session, {required List<S> objects}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.createMany(model.databaseTable, objects: objects.map((e) => adapter.toMap(e)).toList());
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
  }

  Future<TransformEither<Exception, S>> update(TransformDatabaseSession session, {required S object}) async {
    TransformEither<Exception, Map<String, dynamic>> result = await session.update(model.databaseTable, object: adapter.toMap(object));
    return result.fold((left) => Left(result.left), (right) => Right(adapter.fromMap(result.right)));
  }

  Future<TransformEither<Exception, List<S>>> updateMany(TransformDatabaseSession session, {required List<S> objects}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.updateMany(model.databaseTable, objects: objects.map((e) => adapter.toMap(e)).toList());
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
  }

  Future<TransformEither<Exception, S>> upsert(TransformDatabaseSession session, {required S object}) async {
    TransformEither<Exception, Map<String, dynamic>> result = await session.upsert(model.databaseTable, object: adapter.toMap(object));
    return result.fold((left) => Left(result.left), (right) => Right(adapter.fromMap(result.right)));
  }

  Future<TransformEither<Exception, List<S>>> upsertMany(TransformDatabaseSession session, {required List<S> objects}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.upsertMany(model.databaseTable, objects: objects.map((e) => adapter.toMap(e)).toList());
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
  }

  Future<TransformEither<Exception, S>> delete(TransformDatabaseSession session, {required S object}) async {
    TransformEither<Exception, Map<String, dynamic>> result = await session.delete(model.databaseTable, object: adapter.toMap(object));
    return result.fold((left) => Left(result.left), (right) => Right(adapter.fromMap(result.right)));
  }

  Future<TransformEither<Exception, List<S>>> deleteMany(TransformDatabaseSession session, {required List<S> objects}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.deleteMany(model.databaseTable, objects: objects.map((e) => adapter.toMap(e)).toList());
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
  }

   */

/*
  Future<TransformEither<Exception, S?>> findUnique(TransformDatabaseSession session, {required Map<String, dynamic> where}) async {
    TransformEither<Exception, Map<String, dynamic>?> result = await session.findUnique(session, where: where);
    return result.fold((left) => Left(result.left), (right) => Right(result.right != null ? adapter.fromMap(result.right!) : null));
  }

  Future<TransformEither<Exception, List<S>>> findMany(TransformDatabaseSession session, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset}) async {
    TransformEither<Exception, List<Map<String, dynamic>>> result = await model.databaseTable.findMany(session, where: where, orderBy: orderBy, limit: limit, offset: offset);
    return result.fold((left) => Left(result.left), (right) => Right(result.right.map((e) => adapter.fromMap(e)).toList()));
  }
   */
}
