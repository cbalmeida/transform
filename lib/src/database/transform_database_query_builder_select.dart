part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderSelect<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderSelect(super.adapter);

  List<String>? _columns;

  TransformDatabaseQueryBuilderSelect<S> columns(List<String> columns) {
    _columns = columns;
    return this;
  }

  TransformDatabaseTable? _from;

  TransformDatabaseQueryBuilderSelect<S> from(TransformDatabaseTable from) {
    _from = from;
    return this;
  }

  TransformDatabaseQueryBuilderWhere? _where;

  TransformDatabaseQueryBuilderSelect<S> where(TransformDatabaseQueryBuilderCondition condition) {
    _where = TransformDatabaseQueryBuilderWhere.where(condition);
    return this;
  }

  TransformDatabaseQueryBuilderSelect<S> and(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling and()");
    _where = _where!.and(condition);
    return this;
  }

  TransformDatabaseQueryBuilderSelect<S> or(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling or()");
    _where = _where!.or(condition);
    return this;
  }

  List<TransformDatabaseQueryBuilderOrderBy>? _orderByColumns;

  TransformDatabaseQueryBuilderSelect<S> orderBy(List<TransformDatabaseQueryBuilderOrderBy> orderByColumns) {
    _orderByColumns = orderByColumns;
    return this;
  }

  int? _limit;

  TransformDatabaseQueryBuilderSelect<S> limit(int value) {
    _limit = value;
    return this;
  }

  int? _offset;

  TransformDatabaseQueryBuilderSelect<S> offset(int value) {
    _offset = value;
    return this;
  }

  @override
  TransformDatabasePreparedSql prepareSql(TransformDatabaseType databaseType) {
    TransformDatabasePreparedSql preparedSql = TransformDatabasePreparedSql(databaseType);
    preparedSql.addSql("select ");
    if (_columns == null) {
      preparedSql.addSql("*");
    } else {
      preparedSql.addSql(_columns!.join(", "));
    }

    if (_from != null) {
      preparedSql.addNewLine();
      preparedSql.addSql("from ${_from!.sql}");
    }

    _where?.prepareSql(preparedSql);

    if (_orderByColumns != null) {
      preparedSql.addNewLine();
      preparedSql.addSql("order by ");
      for (int i = 0; i < _orderByColumns!.length; i++) {
        _orderByColumns![i].prepareSql(preparedSql);
        if (i != _orderByColumns!.length - 1) preparedSql.addSql(", ");
      }
    }

    if (_limit != null) {
      preparedSql.addNewLine();
      preparedSql.addSql("limit $_limit");
    }

    if (_offset != null) {
      preparedSql.addNewLine();
      preparedSql.addSql("offset $_offset");
    }

    return preparedSql;
  }
}
