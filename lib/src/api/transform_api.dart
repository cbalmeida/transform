import 'package:shelf_router/shelf_router.dart';

import '../../transform.dart';

abstract class TransformApi {
  final TransformInjector injector;

  TransformApi(this.injector);

  int get version;

  List<TransformRoute> get routes;

  Router get router {
    final router = Router();
    for (TransformRoute route in routes) {
      route.addToRouter(router);
    }
    return router;
  }
}
