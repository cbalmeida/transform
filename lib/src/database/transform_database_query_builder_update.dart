part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderUpdate<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderUpdate(super.adapter);

  Map<String, dynamic>? _set;

  TransformDatabaseQueryBuilderUpdate<S> setValue(S value) {
    if (_into == null) throw Exception("You must call into() before calling setValue()");
    _set = adapter.toMap(value).withEncodedValues();
    List<TransformDatabaseColumn> primaryKeyColumns = _into!.primaryKeyColumns;
    if (primaryKeyColumns.isEmpty) throw Exception("Primary key columns not found!");
    where(primaryKeyColumns.first.equals(_set![primaryKeyColumns.first.name]));
    for (TransformDatabaseColumn column in primaryKeyColumns.skip(1)) {
      and(column.equals(_set![column.name]));
    }
    return this;
  }

  TransformDatabaseQueryBuilderUpdate<S> set(Map<String, dynamic> values) {
    _set = values.withEncodedValues();
    return this;
  }

  TransformDatabaseTable? _into;

  TransformDatabaseQueryBuilderUpdate<S> into(TransformDatabaseTable table) {
    _into = table;
    return this;
  }

  TransformDatabaseQueryBuilderWhere? _where;

  TransformDatabaseQueryBuilderUpdate<S> where(TransformDatabaseQueryBuilderCondition condition) {
    _where = TransformDatabaseQueryBuilderWhere.where(condition);
    return this;
  }

  TransformDatabaseQueryBuilderUpdate<S> and(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling and()");
    _where = _where!.and(condition);
    return this;
  }

  TransformDatabaseQueryBuilderUpdate<S> or(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling or()");
    _where = _where!.or(condition);
    return this;
  }

  @override
  TransformDatabasePreparedSql prepareSql(TransformDatabaseType databaseType) {
    if (_into == null) throw Exception("You must call into() before calling prepareSql() or execute()");
    if (_set == null) throw Exception("You must call set() before calling prepareSql() or execute()");
    if (_where == null) throw Exception("You must call where() before calling prepareSql() or execute()");

    TransformDatabasePreparedSql preparedSql = TransformDatabasePreparedSql(databaseType);
    preparedSql.addSql("update ${_into!.sql}");
    preparedSql.addNewLine();
    preparedSql.addSql("set ");
    for (String key in _set!.keys) {
      preparedSql.addNewLine();
      preparedSql.addSql("$key = ");
      preparedSql.addParam(_set![key]);
      if (key != _set!.keys.last) {
        preparedSql.addSql(", ");
      }
    }

    _where!.prepareSql(preparedSql);

    preparedSql.addNewLine();
    preparedSql.addSql("returning *");

    return preparedSql;
  }
}
