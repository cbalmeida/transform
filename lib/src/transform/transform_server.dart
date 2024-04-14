import '../../transform.dart';

class TransformServer {
  final TransformDatabase database;
  final List<TransformObject> objects;
  final List<TransformRoute> routes;

  TransformServer({
    required this.database,
    required this.objects,
    required this.routes,
  });

  late final Map<Type, TransformObject> _objectsMap = Map.fromEntries(objects.map((e) => MapEntry(e.runtimeType, e)));

  T get<T extends TransformObject>() => _objectsMap[T] as T;
}
