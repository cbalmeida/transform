import '../../transform.dart';

abstract class TransformObjects {
  TransformObjects();

  List<TransformObject> objects = [];

  void createObjects(TransformInjector injector);
}
