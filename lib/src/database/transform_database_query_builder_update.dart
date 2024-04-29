part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderUpdate<S> extends TransformDatabaseQueryBuilder<S> {
  final TransformModelAdapter<S> adapter;

  TransformDatabaseQueryBuilderUpdate(this.adapter);

  Map<String, dynamic>? _values;

  TransformDatabaseQueryBuilderUpdate set(Map<String, dynamic> values) {
    _values = values;
    return this;
  }

  TransformDatabaseTable? _table;

  TransformDatabaseQueryBuilderUpdate table(TransformDatabaseTable table) {
    _table = table;
    return this;
  }

  TransformDatabaseQueryBuilderWhere? _where;

  TransformDatabaseQueryBuilderUpdate where(TransformDatabaseQueryBuilderCondition condition) {
    _where = TransformDatabaseQueryBuilderWhere.where(condition);
    return this;
  }

  TransformDatabaseQueryBuilderUpdate and(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling and()");
    _where = _where!.and(condition);
    return this;
  }

  TransformDatabaseQueryBuilderUpdate or(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling or()");
    _where = _where!.or(condition);
    return this;
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    String tableSql = _table?.sql ?? "";
    List<String> values = _values!.entries.map((e) => "${e.key} = ${e.value}").toList();
    String setSql = values.join(", ");
    String whereSql = _where == null ? "" : "where ${_where!.sql}";
    String sql = "update $tableSql \n set $setSql \n $whereSql";
    return sql;
  }

  Future<TransformEither<Exception, List<S>>> execute(TransformDatabaseSession session) async {
    String sql = asSql(session.databaseType);
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.execute(sql);
    return result.fold((left) => Left(result.left), (right) => Right(right.map((e) => adapter.fromMap(e)).toList()));
  }
}
