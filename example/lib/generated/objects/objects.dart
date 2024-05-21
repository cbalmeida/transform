import 'package:testeexemplo/generated/generated.dart';
import 'package:transform/transform.dart';

class Objects extends TransformObjects {
  @override
  void createObjects(TransformInjector injector) {
    objects = [];

    objects.add(injector.addInstance<ProdutoObject>(ProdutoObject()));
  }
}
