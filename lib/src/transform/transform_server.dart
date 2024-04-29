/*
import '../../transform.dart';

class TransformServer {
  final TransformWebServer webserver;
  final TransformJWT jwt;
  final TransformDatabase database;
  final List<TransformObject> objects;

  TransformServer({
    required this.webserver,
    required this.jwt,
    required this.database,
    required this.objects,
  });

  late final Map<Type, TransformObject> _objectsMap = Map.fromEntries(objects.map((e) => MapEntry(e.runtimeType, e)));
  T object<T extends TransformObject>() => _objectsMap[T] as T;
}
*/
