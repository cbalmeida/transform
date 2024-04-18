part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderSelect<S> extends TransformDatabaseQueryBuilder<S> {
  TransformDatabaseQueryBuilderSelect({required S? Function(List<Map<String, dynamic>> result) convertResult}) : super(convertResult);

  List<String>? _columns;

  TransformDatabaseQueryBuilderSelect columns(List<String> columns) {
    _columns = columns;
    return this;
  }

  String? _from;

  TransformDatabaseQueryBuilderSelect from(String from) {
    _from = from;
    return this;
  }

  TransformDatabaseQueryBuilderWhere? _where;

  TransformDatabaseQueryBuilderSelect where(TransformDatabaseQueryBuilderCondition condition) {
    _where = TransformDatabaseQueryBuilderWhere.where(condition);
    return this;
  }

  TransformDatabaseQueryBuilderSelect and(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling and()");
    _where = _where!.and(condition);
    return this;
  }

  TransformDatabaseQueryBuilderSelect or(TransformDatabaseQueryBuilderCondition condition) {
    if (_where == null) throw Exception("You must call where() before calling or()");
    _where = _where!.or(condition);
    return this;
  }

  List<TransformDatabaseQueryBuilderOrderBy>? _orderByColumns;

  TransformDatabaseQueryBuilderSelect orderBy(List<TransformDatabaseQueryBuilderOrderBy> orderByColumns) {
    _orderByColumns = orderByColumns;
    return this;
  }

  int? _limit;

  TransformDatabaseQueryBuilderSelect limit(int value) {
    _limit = value;
    return this;
  }

  int? _offset;

  TransformDatabaseQueryBuilderSelect offset(int value) {
    _offset = value;
    return this;
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    String columnsSql = ((_columns ?? ['*'])).join(", ");
    String fromSql = _from == null ? "" : "from $_from";
    String whereSql = _where == null ? "" : "where ${_where!.sql}";
    String orderBySql = _orderByColumns == null ? "" : "order by ${_orderByColumns!.map((e) => "${e.columnName} ${e.ascending ? 'asc' : 'desc'}").join(", ")}";
    String limitSql = _limit == null ? "" : "limit $_limit";
    String offsetSql = _offset == null ? "" : "offset $_offset";
    String sql = "select  \n  $columnsSql  \n  $fromSql  \n  $whereSql  \n  $orderBySql \n  $limitSql  \n  $offsetSql";
    return sql;
  }
}
