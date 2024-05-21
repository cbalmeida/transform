import 'package:testeexemplo/src/routes/v1/produto/get_produto_all.dart';
import 'package:testeexemplo/src/routes/v1/produto/get_produto_by_id.dart';
import 'package:testeexemplo/src/routes/v1/produto/post_produto.dart';
import 'package:transform/transform.dart';

import 'images/get_images.dart';

class ApiV1 extends TransformRoutes {
  ApiV1();

  @override
  String get path => "/api/v1";

  @override
  void createRoutes(TransformInjector injector) {
    routes = [
      GetProdutoByIdRoute(injector),
      GetProdutoAllRoute(injector),
      PostProdutoRoute(injector),
      GetImagesRoute(injector),
    ];
  }
}
