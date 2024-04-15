import 'package:testeexemplo/src/webserver/webserver.dart';
import 'package:transform/transform.dart';

import '../src/database/postgres.dart';
import 'generated.dart';

class Transform extends TransformServer {
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

      // await instance.database.connect();
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

  ProdutoObject get produto => get<ProdutoObject>();
}
