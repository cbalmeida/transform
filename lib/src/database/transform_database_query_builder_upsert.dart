part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderUpsert<S> extends TransformDatabaseQueryBuilder<S> {
  final TransformModelAdapter<S> adapter;

  TransformDatabaseQueryBuilderUpsert(this.adapter);

  TransformDatabaseTable? _table;
  TransformDatabaseQueryBuilderUpsert into(TransformDatabaseTable table) {
    _table = table;
    return this;
  }

  List<TransformDatabaseColumn>? _columns;

  List<S>? _values;
  TransformDatabaseQueryBuilderUpsert values(List<S> values) {
    _values = values;
    return this;
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    List<String> columns = _columns?.map((e) => e.name).toList() ?? _table?.columns.map((e) => e.name).toList() ?? [];
    String tableName = _table?.sql ?? "";
    String columnsSql = (columns).join(", ");
    String valuesSql = columns.map((e) => "@$e").join(", ");
    String primaryKeyColumns = _table?.columns.where((element) => element.isPrimaryKey).map((e) => e.name).join(", ") ?? "";
    String sql = "insert into $tableName ($columnsSql) values ($valuesSql) ";
    sql += "on conflict ($primaryKeyColumns) do update set ";
    sql += columns.map((e) => "$e = @$e").join(", ");
    sql += "returning *";
    return sql;
  }

  Future<TransformEither<Exception, List<S>>> execute(TransformDatabaseSession session) async {
    if ((_values ?? []).isEmpty) throw Exception("You must call values() before calling execute()");
    List<S> resultValues = [];
    for (S value in _values!) {
      Map<String, dynamic> objectValue = adapter.toMap(value);
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
