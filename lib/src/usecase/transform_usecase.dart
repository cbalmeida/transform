import 'package:transform/src/database/transform_database.dart';

abstract class TransformUseCase<T> {
  final TransformDatabase database;

  TransformUseCase({required this.database});
}
