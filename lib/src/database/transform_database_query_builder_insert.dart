part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderInsert<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderInsert(super.adapter);

  TransformDatabaseTable? _into;
  TransformDatabaseQueryBuilderInsert<S> into(TransformDatabaseTable table) {
    _into = table;
    return this;
  }

  S? _values;
  TransformDatabaseQueryBuilderInsert<S> values(S values) {
    _values = values;
    return this;
  }

  bool _onConflictDoNothing = false;
  TransformDatabaseQueryBuilderInsert<S> onConflictDoNothing() {
    _onConflictDoNothing = true;
    return this;
  }

  @override
  TransformDatabasePreparedSql prepareSql(TransformDatabaseType databaseType) {
    if (_into == null) throw Exception("You must call into() before calling prepareSql() or execute()");
    if (_values == null) throw Exception("You must call values() before calling prepareSql() or execute()");

    TransformDatabasePreparedSql preparedSql = TransformDatabasePreparedSql(databaseType);
    preparedSql.addSql("insert into ${_into!.sql}");

    Map<String, dynamic> parameters = adapter.toMap(_values as S).withEncodedValues();
    parameters.removeWhere((key, value) => value == null);

    String columnsSql = parameters.keys.join(", ");
    preparedSql.addNewLine();
    preparedSql.addSql("( $columnsSql )");

    preparedSql.addNewLine();
    preparedSql.addSql("values");
    preparedSql.addNewLine();
    preparedSql.addSql("( ");
    List<String> columns = parameters.keys.toList();
    for (String column in columns) {
      preparedSql.addParam(parameters[column]);
      if (column != columns.last) preparedSql.addSql(", ");
    }
    preparedSql.addNewLine();
    preparedSql.addSql(" )");

    if (_onConflictDoNothing) {
      preparedSql.addNewLine();
      preparedSql.addSql(" on conflict do nothing");
    }

    preparedSql.addNewLine();
    preparedSql.addSql("returning *");

    return preparedSql;
  }
}
