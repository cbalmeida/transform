import 'dart:core';

import '../../transform.dart';

part 'transform_database_query_builder_delete.dart';
part 'transform_database_query_builder_insert.dart';
part 'transform_database_query_builder_raw.dart';
part 'transform_database_query_builder_select.dart';
part 'transform_database_query_builder_update.dart';
part 'transform_database_query_builder_upsert.dart';

class TransformDatabasePreparedSql {
  final TransformDatabaseType databaseType;

  TransformDatabasePreparedSql(this.databaseType);

  String _sql = '';
  String get sql => _sql;

  final Map<String, dynamic> _parameters = {};
  Map<String, dynamic> get parameters => _parameters;

  int get nextParamIndex => _parameters.length + 1;

  void addNewLine() => _sql += '\n';

  void addSql(String sql) => _sql += sql;

  void addParam(dynamic value) {
    String paramName = nextParamIndex.toString();
    _sql += "@$paramName";
    _parameters[paramName] = value;
  }
}

abstract class TransformDatabaseQueryBuilder<S> {
  final TransformModelAdapter<S> adapter;

  TransformDatabaseQueryBuilder(this.adapter);

  TransformDatabasePreparedSql prepareSql(TransformDatabaseType databaseType);

  Future<TransformEither<Exception, List<S>>> execute(TransformDatabaseSession session) async {
    try {
      final TransformDatabasePreparedSql preparedSql = prepareSql(session.databaseType);
      final TransformEither<Exception, List<Map<String, dynamic>>> result = await session.executePreparedSql(preparedSql);
      if (result.isLeft) {
        return Left(result.left);
      }
      return Right(result.right.map((e) => adapter.fromMap(e)).toList());
    } catch (e) {
      return Left(e as Exception);
    }
  }
}

class TransformDatabaseQueryBuilderCondition {
  dynamic firstVar;

  dynamic secondVar;

  String operator;

  TransformDatabaseQueryBuilderCondition._(this.firstVar, this.operator, this.secondVar);

  void prepareSql(TransformDatabasePreparedSql preparedSql) {
    if (firstVar is TransformDatabaseColumn) {
      preparedSql.addSql("${firstVar.name}");
    } else {
      preparedSql.addParam(firstVar);
    }
    preparedSql.addSql(" $operator ");
    if (secondVar != null) {
      if (secondVar is TransformDatabaseColumn) {
        preparedSql.addSql("${secondVar.name}");
      } else {
        preparedSql.addParam(secondVar);
      }
    }
  }

  factory TransformDatabaseQueryBuilderCondition.isNull(dynamic firstVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'is null', null);
  factory TransformDatabaseQueryBuilderCondition.isNotNull(dynamic firstVar) => TransformDatabaseQueryBuilderCondition._(firstVar, 'is not null', null);
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
  final List<TransformDatabaseQueryBuilderJunction?> _junctions = [];
  final List<TransformDatabaseQueryBuilderCondition?> _conditions = [];

  TransformDatabaseQueryBuilderWhere._();

  TransformDatabaseQueryBuilderWhere _addCondition(TransformDatabaseQueryBuilderJunction junction, TransformDatabaseQueryBuilderCondition condition) {
    _junctions.add(junction);
    _conditions.add(condition);
    return this;
  }

  void prepareSql(TransformDatabasePreparedSql preparedSql) {
    if (_conditions.isEmpty) return;
    preparedSql.addNewLine();
    preparedSql.addSql("where");
    for (int i = 0; i < _conditions.length; i++) {
      TransformDatabaseQueryBuilderJunction? junction = _junctions[i];
      if (junction != null) {
        preparedSql.addNewLine();
        preparedSql.addSql(" ${junction.sql} ");
      }
      TransformDatabaseQueryBuilderCondition? condition = _conditions[i];
      if (condition != null) condition.prepareSql(preparedSql);
    }
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

  void prepareSql(TransformDatabasePreparedSql preparedSql) {
    preparedSql.addSql("$columnName ${ascending ? 'asc' : 'desc'}");
  }

  factory TransformDatabaseQueryBuilderOrderBy.asc(String columnName) => TransformDatabaseQueryBuilderOrderBy._(columnName, true);

  factory TransformDatabaseQueryBuilderOrderBy.desc(String columnName) => TransformDatabaseQueryBuilderOrderBy._(columnName, false);
}
