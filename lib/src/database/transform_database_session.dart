import '../../transform.dart';

abstract class TransformDatabaseSession {
  TransformDatabaseType get databaseType;

  bool get isOpen;

  Future<void> get closed;

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> executeRawQuery(String query, {Map<String, dynamic>? parameters});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> executePreparedSql(TransformDatabasePreparedSql preparedSql) => executeRawQuery(preparedSql.sql, parameters: preparedSql.parameters);

  Future<void> rollback();

  Future<TransformEither<Exception, bool>> checkDatabaseConnection();

  Future<TransformEither<Exception, int>> tableCount(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> tableHasRows(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> tableExists(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> columnExists(TransformDatabaseTable table, TransformDatabaseColumn column);

  Future<TransformEither<Exception, bool>> primaryKeyExists(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> createTable(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> createColumn(TransformDatabaseTable table, TransformDatabaseColumn column);

  //Future<TransformEither<Exception, Map<String, dynamic>?>> selectFirst(TransformDatabaseTable table, {TransformDatabaseWhere? where, List<String>? columns, List<String>? orderBy});

  //Future<TransformEither<Exception, List<Map<String, dynamic>>>> select(TransformDatabaseTable table, {TransformDatabaseWhere? where, List<String>? columns, List<String>? orderBy, int? limit, int? offset});

  //Future<TransformEither<Exception, int>> count(TransformDatabaseTable table, {TransformDatabaseWhere? where});

  /*

  Future<TransformEither<Exception, Map<String, dynamic>>> create(TransformDatabaseTable table, {required Map<String, dynamic> object});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> createMany(TransformDatabaseTable table, {required List<Map<String, dynamic>> objects});

  Future<TransformEither<Exception, Map<String, dynamic>>> update(TransformDatabaseTable table, {required Map<String, dynamic> object});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> updateMany(TransformDatabaseTable table, {required List<Map<String, dynamic>> objects});

  Future<TransformEither<Exception, Map<String, dynamic>>> upsert(TransformDatabaseTable table, {required Map<String, dynamic> object});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> upsertMany(TransformDatabaseTable table, {required List<Map<String, dynamic>> objects});

  Future<TransformEither<Exception, Map<String, dynamic>>> delete(TransformDatabaseTable table, {required Map<String, dynamic> object});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> deleteMany(TransformDatabaseTable table, {required List<Map<String, dynamic>> objects});

  Future<TransformEither<Exception, Map<String, dynamic>>> deleteAll(TransformDatabaseTable table);

   */

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
}
