part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderRaw<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderRaw(super.adapter);

  String? _sql;

  TransformDatabaseQueryBuilderRaw sql(String sql) {
    _sql = sql;
    return this;
  }

  @override
  TransformDatabasePreparedSql prepareSql(TransformDatabaseType databaseType) {
    if (_sql == null) throw Exception("You must call sql() before calling prepareSql() or execute()");
    TransformDatabasePreparedSql preparedSql = TransformDatabasePreparedSql(databaseType);
    preparedSql.addSql(_sql!);
    return preparedSql;
  }
}
