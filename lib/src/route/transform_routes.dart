import 'package:shelf_router/shelf_router.dart';

import '../../transform.dart';

abstract class TransformRoutes {
  TransformRoutes();

  String get path;

  List<TransformRoute> routes = [];

  void createRoutes(TransformInjector injector);

  Router router(TransformInjector injector) {
    createRoutes(injector);

    final router = Router();
    for (TransformRoute route in routes) {
      route.addToRouter(router);
    }
    return router;
  }
}
