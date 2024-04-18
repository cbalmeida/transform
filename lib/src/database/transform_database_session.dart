import '../../transform.dart';

abstract class TransformDatabaseSession {
  TransformDatabaseType get databaseType;

  bool get isOpen;

  Future<void> get closed;

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> execute(String query, {Map<String, dynamic>? parameters});

  Future<void> rollback();

  Future<TransformEither<Exception, bool>> checkDatabaseConnection();

  Future<TransformEither<Exception, int>> tableCount(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> tableHasRows(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> tableExists(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> columnExists(TransformDatabaseTable table, TransformDatabaseColumn column);

  Future<TransformEither<Exception, bool>> primaryKeyExists(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> createTable(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> createColumn(TransformDatabaseTable table, TransformDatabaseColumn column);

  Future<TransformEither<Exception, Map<String, dynamic>?>> findUnique(TransformDatabaseTable table, {required Map<String, dynamic> where});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> findMany(TransformDatabaseTable table, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset});
}
