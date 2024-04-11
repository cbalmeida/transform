import 'package:transform/transform.dart';

import 'produto/produto.dart';

class Transform {
  final TransformDatabaseClass dataBase;

  Transform({required this.dataBase});

  late final ProdutoObject cliente = ProdutoObject(dataBase: dataBase);
}
