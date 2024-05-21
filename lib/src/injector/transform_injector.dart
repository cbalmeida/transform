import 'package:auto_injector/auto_injector.dart';

class TransformInjector {
  TransformInjector();

  final _autoInjector = AutoInjector();

  T get<T>() => _autoInjector.get<T>();

  T? tryGet<T>() => _autoInjector.tryGet<T?>();

  void add<T>(Function constructor) => _autoInjector.add<T>(constructor);

  T addInstance<T>(T instance) {
    _autoInjector.addInstance<T>(instance);
    return instance;
  }

  void addSingleton<T>(Function constructor) => _autoInjector.addSingleton<T>(constructor);

  void addLazySingleton<T>(Function constructor) => _autoInjector.addLazySingleton<T>(constructor);

  void commit() => _autoInjector.commit();

  void dispose() => _autoInjector.dispose();
}
