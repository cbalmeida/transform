import 'package:testeexemplo/generated/produto/produto.dart';
import 'package:transform/transform.dart';

import '../src/database/postgres.dart';
import '../src/routes/produto_get.dart';

class Transform extends TransformServer {
  Transform._({required super.database, required super.objects, required super.routes});

  static Transform? _instance;

  static Transform get instance => _instance ??= newInstance;

  static Transform get newInstance {
    TransformDatabase dataBase = DatabasePostgres();
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
