import '../../transform.dart';

abstract class TransformUseCases {
  TransformUseCases();

  void registerUseCases(TransformInjector injector);
}
