import 'package:testeexemplo/generated/produto/produto.dart';
import 'package:transform/transform.dart';

import '../src/database/postgres.dart';
import '../src/routes/produto_get.dart';

class Transform extends TransformServer {
  Transform._({required super.database, required super.objects, required super.routes});

  static Transform? _instance;

  static Transform get instance {
    if (_instance == null) {
      throw Exception("Server not started!");
    }
    return _instance!;
  }

  static Future<void> start() async {
    try {
      Util.log("Starting server...");

      Util.log("Creating Server instance...");
      _instance = _newInstance;

      await instance.database.start();

      Util.log("Server started!");
      // await instance.database.connect();
    } catch (e) {
      Util.logError("Error starting server: $e");
    }
  }

  static Transform get _newInstance {
    Util.log("Creating database instance...");
    TransformDatabase dataBase = DatabasePostgres();
    Util.log("Database instance created: ${dataBase.type}.");

    Util.log("Creating objects instances...");
    List<TransformObject> objects = [
      ProdutoObject(dataBase: dataBase),
    ];

    List<TransformRoute> routes = [
      ProdutoGetRoute(),
    ];

    return Transform._(
      database: dataBase,
      objects: objects,
      routes: routes,
    );
  }

  ProdutoObject get produto => get<ProdutoObject>();
}
