import 'package:postgres/postgres.dart' as postgres;

import '../../transform.dart';

part 'types/transform_database_postgres.dart';

enum TransformDatabaseType { postgres, mysql }

abstract class TransformDatabase {
  TransformDatabaseType get type;

  Future<TransformEither<Exception, bool>> start() async {
    return transaction<bool>((session) async {
      try {
        Util.log("  Checking Database connection...");
        TransformEither<Exception, bool> resultCheckDatabaseConnection = await session.checkDatabaseConnection();
        if (resultCheckDatabaseConnection.isLeft) throw resultCheckDatabaseConnection.left;

        Util.log("  Creating/updating tables structures...");
        for (TransformDatabaseTable table in tables) {
          Util.log("    '${table.name}'.");
          TransformEither<Exception, bool> resultCreateTable = await session.createTable(table);
          if (resultCreateTable.isLeft) throw resultCreateTable.left;
        }
        return Right(true);
      } on Exception catch (e) {
        return Left(Exception("Error starting Database layer:\n$e"));
      }
    });
  }

  final List<TransformDatabaseTable> tables = [];

  registerTable(TransformDatabaseTable table) => tables.add(table);

  Future<TransformEither<Exception, R>> transaction<R>(Future<TransformEither<Exception, R>> Function(TransformDatabaseSession session) body);
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
