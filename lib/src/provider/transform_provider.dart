import '../../transform.dart';

abstract class TransformProvider {
  TransformProvider();
}

abstract class TransformProviders {
  TransformProviders();

  void registerProviders(TransformInjector injector);
}
