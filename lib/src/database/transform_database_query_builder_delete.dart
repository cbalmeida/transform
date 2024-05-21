part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderDelete<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderDelete(super.adapter);

  TransformDatabaseTable? _from;

  TransformDatabaseQueryBuilderDelete from(TransformDatabaseTable from) {
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
  TransformDatabasePreparedSql prepareSql(TransformDatabaseType databaseType) {
    if (_from == null) throw Exception("You must call from() before calling prepareSql() or execute()");

    TransformDatabasePreparedSql preparedSql = TransformDatabasePreparedSql(databaseType);
    preparedSql.addSql("delete from ${_from!.sql}");
    _where?.prepareSql(preparedSql);
    preparedSql.addNewLine();
    preparedSql.addSql("returning *");

    return preparedSql;
  }
}
