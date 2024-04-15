import 'package:testeexemplo/src/api/v1/routes/produto/produto_get.dart';
import 'package:transform/transform.dart';

class ApiV1 extends TransformApi {
  @override
  int get version => 1;

  @override
  List<TransformRoute> get routes => [
        ProdutoGetRoute(),
      ];
}
