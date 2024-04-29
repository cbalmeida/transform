import 'package:testeexemplo/src/api/v1/routes/images/images_get.dart';
import 'package:testeexemplo/src/api/v1/routes/produto/get_produto_all.dart';
import 'package:testeexemplo/src/api/v1/routes/produto/get_produto_by_id.dart';
import 'package:testeexemplo/src/api/v1/routes/produto/post_produto.dart';
import 'package:testeexemplo/src/api/v1/routes/signin/post_signin.dart';
import 'package:testeexemplo/src/api/v1/routes/user/post_user.dart';
import 'package:transform/transform.dart';

class ApiV1 extends TransformApi {
  ApiV1(super.injector);

  @override
  int get version => 1;

  @override
  List<TransformRoute> get routes => [
        PostUserRoute(injector),
        PostSignInRoute(injector),
        GetProdutoByIdRoute(injector),
        GetProdutoAllRoute(injector),
        PostProdutoRoute(injector),
        ImagesGetRoute(injector),
      ];
}
