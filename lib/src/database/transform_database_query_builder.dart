import '../../transform.dart';

part 'transform_database_query_builder_delete.dart';
part 'transform_database_query_builder_insert.dart';
part 'transform_database_query_builder_raw.dart';
part 'transform_database_query_builder_select.dart';
part 'transform_database_query_builder_update.dart';
part 'transform_database_query_builder_upsert.dart';

abstract class TransformDatabaseQueryBuilder<S> {
  String asSql(TransformDatabaseType databaseType);
}

class TransformDatabaseQueryBuilderCondition {
  dynamic firstVar;

  dynamic secondVar;

  String operator;

  TransformDatabaseQueryBuilderCondition._(this.firstVar, this.operator, this.secondVar);

  String get firstVarStr {
    if (firstVar is String) return "'$firstVar'";
    return firstVar.toString();
  }

  String get secondVarStr {
    if (secondVar is String) return "'$secondVar'";
    return secondVar.toString();
  }

  String get sql => '( $firstVarStr $operator $secondVarStr )';

  factory TransformDatabaseQueryBuilderCondition.equals(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '=', secondVar);
  factory TransformDatabaseQueryBuilderCondition.notEquals(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '<>', secondVar);
  factory TransformDatabaseQueryBuilderCondition.inValues(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'in', secondVar);
  factory TransformDatabaseQueryBuilderCondition.notInValues(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'not in', secondVar);
  factory TransformDatabaseQueryBuilderCondition.lowerThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '<', secondVar);
  factory TransformDatabaseQueryBuilderCondition.lowerOrEqualsThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '<=', secondVar);
  factory TransformDatabaseQueryBuilderCondition.biggerThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '>', secondVar);
  factory TransformDatabaseQueryBuilderCondition.biggerOrEqualsThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '>=', secondVar);
  factory TransformDatabaseQueryBuilderCondition.exists(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'exists', secondVar);
}

class TransformDatabaseQueryBuilderJunction {
  final String sql;
  TransformDatabaseQueryBuilderJunction._(this.sql);

  factory TransformDatabaseQueryBuilderJunction.none() => TransformDatabaseQueryBuilderJunction._("");
  factory TransformDatabaseQueryBuilderJunction.and() => TransformDatabaseQueryBuilderJunction._("and");
  factory TransformDatabaseQueryBuilderJunction.or() => TransformDatabaseQueryBuilderJunction._("or");
}

class TransformDatabaseQueryBuilderWhere {
  final List<String> _sql = [];

  TransformDatabaseQueryBuilderWhere._();

  String get sql => _sql.join(" ");

  TransformDatabaseQueryBuilderWhere _addCondition(TransformDatabaseQueryBuilderJunction junction, TransformDatabaseQueryBuilderCondition condition) {
    if (_sql.isNotEmpty) _sql.add(junction.sql);
    _sql.add("( ${condition.sql} )");
    return this;
  }

  factory TransformDatabaseQueryBuilderWhere.where(TransformDatabaseQueryBuilderCondition condition) {
    return TransformDatabaseQueryBuilderWhere._().._addCondition(TransformDatabaseQueryBuilderJunction.none(), condition);
  }

  TransformDatabaseQueryBuilderWhere and(TransformDatabaseQueryBuilderCondition condition) {
    return _addCondition(TransformDatabaseQueryBuilderJunction.and(), condition);
  }

  TransformDatabaseQueryBuilderWhere or(TransformDatabaseQueryBuilderCondition condition) {
    return _addCondition(TransformDatabaseQueryBuilderJunction.or(), condition);
  }
}

class TransformDatabaseQueryBuilderOrderBy {
  final String columnName;
  final bool ascending;

  TransformDatabaseQueryBuilderOrderBy._(this.columnName, this.ascending);

  factory TransformDatabaseQueryBuilderOrderBy.asc(String columnName) => TransformDatabaseQueryBuilderOrderBy._(columnName, true);

  factory TransformDatabaseQueryBuilderOrderBy.desc(String columnName) => TransformDatabaseQueryBuilderOrderBy._(columnName, false);
}
