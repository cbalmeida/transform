import 'package:testeexemplo/src/api/v1/api_v1.dart';
import 'package:transform/transform.dart';

class Apis {
  final TransformInjector injector;

  Apis(this.injector);

  late final List<TransformApi> all = [
    ApiV1(injector),
  ];
}
