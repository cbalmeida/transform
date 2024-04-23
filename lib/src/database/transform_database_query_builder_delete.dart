part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderDelete<S> extends TransformDatabaseQueryBuilder<S> {
  final TransformModelAdapter<S> adapter;

  TransformDatabaseQueryBuilderDelete(this.adapter);

  String? _from;

  TransformDatabaseQueryBuilderDelete from(String from) {
    _from = from;
    return this;
  }

  TransformDatabaseQueryBuilderWhere? _where;

  TransformDatabaseQueryBuilderDelete where(TransformDatabaseQueryBuilderCondition condition) {
    _where = TransformDatabaseQueryBuilderWhere.where(condition);
    return this;
  }

  TransformDatabaseQueryBuilderDelete and(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling and()");
    _where = _where!.and(condition);
    return this;
  }

  TransformDatabaseQueryBuilderDelete or(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling or()");
    _where = _where!.or(condition);
    return this;
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    String fromSql = _from == null ? "" : "from $_from";
    String whereSql = _where == null ? "" : "where ${_where!.sql}";
    String sql = "delete  \n  $fromSql  \n  $whereSql ";
    return sql;
  }

  Future<TransformEither<Exception, List<S>>> execute(TransformDatabaseSession session) async {
    String sql = asSql(session.databaseType);
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.execute(sql);
    return result.fold((left) => Left(result.left), (right) => Right(right.map((e) => adapter.fromMap(e)).toList()));
  }
}
