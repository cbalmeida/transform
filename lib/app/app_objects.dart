import '../transform.dart';

class AppObjects extends TransformObjects {
  @override
  void createObjects(TransformInjector injector) {
    objects = [];
    objects.add(injector.addInstance<UserObject>(UserObject()));
    objects.add(injector.addInstance<EmailOutBoxObject>(EmailOutBoxObject()));
  }
}
