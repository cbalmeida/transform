import '../../transform.dart';

abstract class TransformUseCase<T> {
  final TransformUseCaseParams params;

  TransformUseCase({required this.params});

  TransformDatabase get database => TransformDatabase.fromParams(params.databaseParams);
}

class TransformUseCaseParams {
  final TransformDatabaseParams databaseParams;
  final TransformWebServerParams webServerParams;
  final TransformJWTParams jwtParams;
  final TransformJWT jwt;
  final TransformEmailSenderParams? emailSenderParams;

  TransformUseCaseParams({required this.databaseParams, required this.webServerParams, required this.jwtParams, required this.jwt, required this.emailSenderParams});
}
