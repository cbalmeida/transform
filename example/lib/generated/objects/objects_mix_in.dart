import 'package:transform/transform.dart';

import 'produto/produto.dart';

mixin ObjectsMixIn on TransformServer {
  T get<T extends TransformObject>();

  ProdutoObject get produto => get<ProdutoObject>();
}
