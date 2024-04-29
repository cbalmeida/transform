part of 'transform_database_query_builder.dart';

class TransformDatabaseQueryBuilderRaw<S> extends TransformDatabaseQueryBuilder<S> {
  final TransformModelAdapter<S> adapter;

  TransformDatabaseQueryBuilderRaw(this.adapter);

  String? _sql;

  TransformDatabaseQueryBuilderRaw sql(String sql) {
    _sql = sql;
    return this;
  }

  @override
  String asSql(TransformDatabaseType databaseType) {
    return _sql ?? "";
  }

  Future<TransformEither<Exception, List<S>>> execute(TransformDatabaseSession session) async {
    String sql = asSql(session.databaseType);
    TransformEither<Exception, List<Map<String, dynamic>>> result = await session.execute(sql);
    return result.fold((left) => Left(result.left), (right) => Right(right.map((e) => adapter.fromMap(e)).toList()));
  }
}
