import 'dart:convert';
import 'dart:io';

import 'package:postgres/postgres.dart' as postgres;

import '../../transform.dart';

part 'types/transform_database_postgres.dart';

enum TransformDatabaseType { postgres, mysql }

abstract class TransformDatabase {
  TransformDatabaseType get type;

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
