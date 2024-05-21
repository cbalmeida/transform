part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderUpsert<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderUpsert(super.adapter);

  TransformDatabaseTable? _into;
  TransformDatabaseQueryBuilderUpsert<S> into(TransformDatabaseTable table) {
    _into = table;
    return this;
  }

  S? _values;
  TransformDatabaseQueryBuilderUpsert<S> values(S values) {
    _values = values;
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

    List<TransformDatabaseColumn> primaryKeyColumns = _into!.primaryKeyColumns;
    String primaryKeyColumnsNames = primaryKeyColumns.map((e) => e.name).join(", ");
    preparedSql.addNewLine();
    preparedSql.addSql(" on conflict ($primaryKeyColumnsNames) do update set ");
    for (String column in columns) {
      preparedSql.addSql("$column = ");
      preparedSql.addParam(parameters[column]);
      if (column != columns.last) preparedSql.addSql(", ");
    }
    preparedSql.addNewLine();
    preparedSql.addSql(" where ");
    preparedSql.addSql("${primaryKeyColumns[0].name} = ");
    preparedSql.addParam(parameters[primaryKeyColumns[0].name]);
    for (TransformDatabaseColumn column in primaryKeyColumns.skip(1)) {
      preparedSql.addNewLine();
      preparedSql.addSql(" and ");
      preparedSql.addSql("${column.name} = ");
      preparedSql.addParam(parameters[column.name]);
    }

    preparedSql.addNewLine();
    preparedSql.addSql("returning *");

    return preparedSql;
  }
}
