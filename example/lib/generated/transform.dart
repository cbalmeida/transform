import 'package:testeexemplo/generated/produto/produto.dart';
import 'package:transform/transform.dart';

import '../src/database/postgres.dart';
import '../src/routes/produto_get.dart';

class Transform extends TransformServer {
  static Transform? _instance;
  static Transform get instance => _instance ??= Transform._();

  Transform._()
      : super(
          database: DatabasePostgres.teste(),
          objects: [
            ProdutoObject(dataBase: DatabasePostgres.teste()),
          ],
          routes: [
            ProdutoGetRoute(),
          ],
        );

  ProdutoObject get produto => get<ProdutoObject>();
}
