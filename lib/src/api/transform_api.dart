import 'package:shelf_router/shelf_router.dart';

import '../../transform.dart';

abstract class TransformApi {
  int get version;

  List<TransformRoute> get routes;

  TransformApi();

  Router get router {
    final router = Router();
    for (TransformRoute route in routes) {
      route.addToRouter(router);
    }
    return router;
  }
}
