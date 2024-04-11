import '../../transform.dart';

abstract class TransformModel {
  String get name;
  String get schema;
  List<TransformModelColumn> get columns;

  TransformDatabaseTable get databaseTable => TransformDatabaseTable(
        name: name,
        schema: schema,
        columns: columns.map((e) => e.databaseColumn).toList(),
      );
}
