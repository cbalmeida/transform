import 'package:testeexemplo/src/api/v1/routes/images/images_get.dart';
import 'package:testeexemplo/src/api/v1/routes/produto/get_produto_all.dart';
import 'package:testeexemplo/src/api/v1/routes/produto/get_produto_by_id.dart';
import 'package:testeexemplo/src/api/v1/routes/produto/post_produto.dart';
import 'package:transform/transform.dart';

class ApiV1 extends TransformApi {
  @override
  int get version => 1;

  @override
  List<TransformRoute> get routes => [
        GetProdutoByIdRoute(),
        GetProdutoAllRoute(),
        PostProdutoRoute(),
        ImagesGetRoute(),
      ];
}
