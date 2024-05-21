import 'package:transform/transform.dart';

class ApiAuth extends TransformRoutes {
  ApiAuth();

  @override
  String get path => "/api/auth";

  @override
  void createRoutes(TransformInjector injector) {
    routes = [
      AuthLoginPostRoute(injector),
      AuthRegisterPostRoute(injector),
      AuthActivatePostRoute(injector),
      AuthForgotPasswordPostRoute(injector),
    ];
  }
}
