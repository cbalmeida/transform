import '../../transform.dart';

part 'transform_database_query_builder_select.dart';

abstract class TransformDatabaseQueryBuilder<S> {
  String asSql(TransformDatabaseType databaseType);

  S? Function(List<Map<String, dynamic>> result) convertResult;

  TransformDatabaseQueryBuilder(this.convertResult);

  Future<TransformEither<Exception, S?>> execute(TransformDatabaseSession session) async {
    String sql = asSql(session.databaseType);
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.execute(sql);
    return result.fold((left) => Left(result.left), (right) => Right(convertResult(right)));
  }
}

class TransformDatabaseQueryBuilderCondition {
  dynamic firstVar;

  dynamic secondVar;

  String operator;

  TransformDatabaseQueryBuilderCondition._(this.firstVar, this.operator, this.secondVar);

  String get sql {
    String firstVarStr = firstVar is String ? "$firstVar" : firstVar.toString();
    String secondVarStr = secondVar is String ? "'$secondVar'" : secondVar.toString();
    return '$firstVarStr $operator $secondVarStr';
  }

  factory TransformDatabaseQueryBuilderCondition.equals(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '=', secondVar);
  factory TransformDatabaseQueryBuilderCondition.notEquals(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '<>', secondVar);
  factory TransformDatabaseQueryBuilderCondition.inValues(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'in', secondVar);
  factory TransformDatabaseQueryBuilderCondition.notInValues(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'not in', secondVar);
  factory TransformDatabaseQueryBuilderCondition.lowerThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '<', secondVar);
  factory TransformDatabaseQueryBuilderCondition.lowerOrEqualsThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '<=', secondVar);
  factory TransformDatabaseQueryBuilderCondition.biggerThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '>', secondVar);
  factory TransformDatabaseQueryBuilderCondition.biggerOrEqualsThan(dynamic firstVar, dynamic secondVar) => TransformDatabaseQueryBuilderCondition._(firstVar, '>=', secondVar);
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
