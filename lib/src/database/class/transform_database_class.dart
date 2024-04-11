import 'package:postgres/postgres.dart' as postgres;

import '../../../transform.dart';

part 'transform_database_class_postgres.dart';

enum TransformDatabaseClassType { postgres, mysql }

abstract class TransformDatabaseClass {
  TransformDatabaseClassType get type;

  Future<List<Map<String, dynamic>>> execute(String query, {Map<String, dynamic>? parameters});

  Future<bool> tableExists(TransformDatabaseTable table);

  Future<bool> columnExists(TransformDatabaseTable table, TransformDatabaseColumn column);

  Future<bool> createTable(TransformDatabaseTable table);

  Future<Map<String, dynamic>?> findUnique(TransformDatabaseTable table, {required Map<String, dynamic> where});

  Future<List<Map<String, dynamic>>> findMany(TransformDatabaseTable table, {required Map<String, dynamic> where, Map<String, dynamic>? orderBy, int? limit, int? offset});
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
