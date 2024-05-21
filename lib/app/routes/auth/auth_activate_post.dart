import 'package:transform/transform.dart';

class AuthActivatePostRouteInput extends TransformRouteInput {
  final String? email;
  final String? verificationCode;
  const AuthActivatePostRouteInput({required this.email, required this.verificationCode});

  factory AuthActivatePostRouteInput.fromMap(Map<String, dynamic> map) {
    return AuthActivatePostRouteInput(email: map["email"], verificationCode: map["verification_code"]);
  }
}

class AuthActivatePostRouteOutput extends TransformRouteOutputJson {
  final String token;
  const AuthActivatePostRouteOutput({required this.token});

  @override
  Map<String, dynamic> get output => {"token": token};
}

class AuthActivatePostRouteHandler extends TransformRouteHandler<AuthActivatePostRouteInput, AuthActivatePostRouteOutput> {
  final AuthActivateUseCase authActivateUseCase;

  AuthActivatePostRouteHandler({
    required super.jwt,
    required this.authActivateUseCase,
    required super.limiter,
  });

  factory AuthActivatePostRouteHandler.create(TransformInjector injector) {
    return AuthActivatePostRouteHandler(
      jwt: injector.get(),
      authActivateUseCase: injector.get(),
      limiter: injector.get(),
    );
  }

  @override
  AuthActivatePostRouteInput inputFromParams(Map<String, dynamic> params) => AuthActivatePostRouteInput.fromMap(params);

  @override
  bool get mustCheckToken => false;

  @override
  Future<TransformRouteResponse<AuthActivatePostRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.email == null) return TransformRouteResponse.badRequest("Parameter 'email' not found");
    if (input.params.verificationCode == null) return TransformRouteResponse.badRequest("Parameter 'verification_code' not found");

    TransformEither<AuthActivateUseCaseException, AuthActivateUseCaseResponse> result = await authActivateUseCase(email: input.params.email!, verificationCode: input.params.verificationCode!);
    if (result.isLeft) {
      AuthActivateUseCaseException exception = result.left;
      switch (exception.type) {
        case AuthActivateUseCaseExceptionType.userNotFound:
          return TransformRouteResponse.badRequest("Email '${input.params.email}' not found");
        case AuthActivateUseCaseExceptionType.tooManyRequests:
          return TransformRouteResponse.tooManyRequests("Too many requests for email '${input.params.email}'");
        case AuthActivateUseCaseExceptionType.verificationCodeInvalid:
          return TransformRouteResponse.unauthorized("Invalid verification code for email '${input.params.email}'");
        case AuthActivateUseCaseExceptionType.userAlreadyVerified:
          return TransformRouteResponse.conflict("Email '${input.params.email}' already verified");
        case AuthActivateUseCaseExceptionType.internalServerError:
          return TransformRouteResponse.internalServerError(exception);
      }
    }

    String token = result.right.token;
    AuthActivatePostRouteOutput output = AuthActivatePostRouteOutput(token: token);
    return TransformRouteResponse.ok(output);
  }
}

class AuthActivatePostRoute extends TransformRoute<AuthActivatePostRouteInput, AuthActivatePostRouteOutput> {
  AuthActivatePostRoute(super.injector);

  @override
  TransformRouteHandler<AuthActivatePostRouteInput, AuthActivatePostRouteOutput> get handler => AuthActivatePostRouteHandler.create(injector);

  @override
  String get path => '/activate';

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;
}
