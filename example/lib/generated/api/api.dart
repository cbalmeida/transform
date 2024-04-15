import 'package:testeexemplo/src/api/v1/api_v1.dart';
import 'package:transform/transform.dart';

class Api {
  static final ApiV1 v1 = ApiV1();

  static final List<TransformApi> all = [
    v1,
  ];
}
