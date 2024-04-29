import '../../transform.dart';

abstract class TransformUseCase<T> {
  final TransformDatabaseParams databaseParams;

  TransformUseCase({required this.databaseParams});

  TransformDatabase get database => TransformDatabase.fromParams(databaseParams);
}
