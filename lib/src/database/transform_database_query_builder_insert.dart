part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderInsert<S> extends TransformDatabaseQueryBuilder<S> {
  final TransformModelAdapter<S> adapter;

  TransformDatabaseQueryBuilderInsert(this.adapter);

  TransformDatabaseTable? _table;
  TransformDatabaseQueryBuilderInsert into(TransformDatabaseTable table) {
    _table = table;
    return this;
  }

  List<TransformDatabaseColumn>? _columns;

  List<S>? _values;
  TransformDatabaseQueryBuilderInsert values(List<S> values) {
    _values = values;
    return this;
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    List<String> columns = _columns?.map((e) => e.name).toList() ?? _table?.columns.map((e) => e.name).toList() ?? [];
    String tableName = _table?.name ?? "";
    String columnsSql = (columns).join(", ");
    String valuesSql = columns.map((e) => "@$e").join(", ");
    String sql = "insert into $tableName ($columnsSql) values ($valuesSql) returning *";
    return sql;
  }

  Future<TransformEither<Exception, List<S>>> execute(TransformDatabaseSession session) async {
    if ((_values ?? []).isEmpty) throw Exception("You must call values() before calling execute()");
    List<S> resultValues = [];
    for (S value in _values!) {
      Map<String, dynamic> objectValue = adapter.toMap(value);
      objectValue.removeWhere((key, value) => value == null);
      _columns = [];
      for (TransformDatabaseColumn column in _table!.columns) {
        if (objectValue.containsKey(column.name)) {
          _columns!.add(column);
        }
      }

      String sql = asSql(session.databaseType);
      final result = await session.execute(sql, parameters: objectValue);
      if (result.isLeft) return Left(result.left);
      resultValues.add(adapter.fromMap(result.right.first));
    }
    return Right(resultValues);
  }
}
