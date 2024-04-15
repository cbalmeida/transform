import 'package:transform/transform.dart';

import 'produto/produto.dart';

class Objects {
  static List<TransformObject> all(TransformDatabase dataBase) => [
        ProdutoObject(dataBase: dataBase),
      ];
}
