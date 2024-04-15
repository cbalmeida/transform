import 'package:postgres/postgres.dart' as postgres;

import '../../transform.dart';

part 'types/transform_database_postgres.dart';

enum TransformDatabaseType { postgres, mysql }

abstract class TransformDatabase {
  TransformDatabaseType get type;

  Future<TransformEither<Exception, bool>> start() async {
    try {
      Util.log("  Checking Database connection...");
      TransformEither<Exception, bool> resultCheckDatabaseConnection = await checkDatabaseConnection();
      if (resultCheckDatabaseConnection.isLeft) throw resultCheckDatabaseConnection.left;

      Util.log("  Creating/updating tables structures...");
      for (TransformDatabaseTable table in tables) {
        Util.log("    '${table.name}'.");
        TransformEither<Exception, bool> resultCreateTable = await createTable(table);
        if (resultCreateTable.isLeft) throw resultCreateTable.left;
      }
      return Right(true);
    } on Exception catch (e) {
      return Left(Exception("Error starting Database layer:\n$e"));
    }
  }

  final List<TransformDatabaseTable> tables = [];

  registerTable(TransformDatabaseTable table) {
    tables.add(table);
  }

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> execute(String query, {Map<String, dynamic>? parameters});

  Future<TransformEither<Exception, bool>> checkDatabaseConnection();

  Future<TransformEither<Exception, bool>> tableExists(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> columnExists(TransformDatabaseTable table, TransformDatabaseColumn column);

  Future<TransformEither<Exception, bool>> primaryKeyExists(TransformDatabaseTable table);

  Future<TransformEither<Exception, bool>> createTable(TransformDatabaseTable table);

  Future<TransformEither<Exception, Map<String, dynamic>?>> findUnique(TransformDatabaseTable table, {required Map<String, dynamic> where});

  Future<TransformEither<Exception, List<Map<String, dynamic>>>> findMany(TransformDatabaseTable table, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset});
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
