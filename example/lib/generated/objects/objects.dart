import 'package:testeexemplo/generated/generated.dart';
import 'package:transform/transform.dart';

class Objects {
  static List<TransformObject> get objects => TransformObject.objects;

  static void register(TransformInjector injector) {
    injector.addInstance<ProdutoObject>(ProdutoObject());
    injector.addInstance<UserObject>(UserObject());
  }
}
