import 'package:testeexemplo/src/webserver/webserver.dart';
import 'package:transform/transform.dart';

import '../generated/generated.dart';
import '../generated/objects/objects_mix_in.dart';
import 'database/postgres.dart';

class Transform extends TransformServer with ObjectsMixIn {
  Transform._({required super.database, required super.webserver, required super.objects});

  static Transform? _instance;

  static Transform get instance {
    if (_instance == null) {
      throw Exception("Server not started!");
    }
    return _instance!;
  }

  static Future<void> start() async {
    try {
      _instance = _newInstance;

      Util.log("============ Database ============");
      TransformEither<Exception, bool> databaseStartResult = await instance.database.start();
      if (databaseStartResult.isLeft) throw databaseStartResult.left;

      Util.log("============ Webserver ============");
      TransformEither<Exception, bool> webServerStartResult = await instance.webserver.start();
      if (webServerStartResult.isLeft) throw webServerStartResult.left;

      Util.log("============ Server ============");
      Util.log("Server initialization completed!");
    } catch (e) {
      Util.logError("Error starting server:\n$e");
    }
  }

  static Transform get _newInstance {
    TransformDatabase dataBase = DatabasePostgres();
    TransformWebServer webServer = WebServer();
    List<TransformObject> objects = Objects.all(dataBase);
    return Transform._(webserver: webServer, database: dataBase, objects: objects);
  }

  late final Map<Type, TransformObject> _objectsMap = Map.fromEntries(objects.map((e) => MapEntry(e.runtimeType, e)));

  @override
  T get<T extends TransformObject>() => _objectsMap[T] as T;
}
