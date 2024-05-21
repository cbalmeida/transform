import 'package:transform/transform.dart';

class AuthLoginPostRouteInput extends TransformRouteInput {
  final String? email;
  final String? password;
  const AuthLoginPostRouteInput({required this.email, required this.password});

  factory AuthLoginPostRouteInput.fromMap(Map<String, dynamic> map) {
    return AuthLoginPostRouteInput(email: map["email"], password: map["password"]);
  }
}

class AuthLoginPostRouteOutput extends TransformRouteOutputJson {
  final String token;
  const AuthLoginPostRouteOutput({required this.token});

  @override
  Map<String, dynamic> get output => {"token": token};
}

class AuthLoginPostRouteHandler extends TransformRouteHandler<AuthLoginPostRouteInput, AuthLoginPostRouteOutput> {
  final AuthLoginUseCase authLoginUseCase;

  AuthLoginPostRouteHandler({
    required super.jwt,
    required this.authLoginUseCase,
    required super.limiter,
  });

  factory AuthLoginPostRouteHandler.create(TransformInjector injector) {
    return AuthLoginPostRouteHandler(
      jwt: injector.get(),
      authLoginUseCase: injector.get(),
      limiter: injector.get(),
    );
  }

  @override
  AuthLoginPostRouteInput inputFromParams(Map<String, dynamic> params) => AuthLoginPostRouteInput.fromMap(params);

  @override
  bool get mustCheckToken => false;

  @override
  Future<TransformRouteResponse<AuthLoginPostRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.email == null) return TransformRouteResponse.badRequest("'email' is required!");
    if (input.params.password == null) return TransformRouteResponse.badRequest("'password' is required!");

    TransformEither<AuthLoginUseCaseException, AuthLoginUseCaseResponse> result = await authLoginUseCase(email: input.params.email!, password: input.params.password!);
    if (result.isLeft) {
      AuthLoginUseCaseException exception = result.left;
      switch (exception.type) {
        case AuthLoginUseCaseExceptionType.userNotFound:
          return TransformRouteResponse.badRequest("User not found. Email:'${input.params.email}'");
        case AuthLoginUseCaseExceptionType.invalidPassword:
          return TransformRouteResponse.unauthorized("Invalid password");
        case AuthLoginUseCaseExceptionType.userNotVerified:
          return TransformRouteResponse.forbidden("User has not been verified. Email:'${input.params.email}' ");
        case AuthLoginUseCaseExceptionType.internalServerError:
          return TransformRouteResponse.internalServerError(exception);
      }
    }

    String token = result.right.token;
    AuthLoginPostRouteOutput output = AuthLoginPostRouteOutput(token: token);
    return TransformRouteResponse.ok(output);
  }
}

class AuthLoginPostRoute extends TransformRoute<AuthLoginPostRouteInput, AuthLoginPostRouteOutput> {
  AuthLoginPostRoute(super.injector);

  @override
  TransformRouteHandler<AuthLoginPostRouteInput, AuthLoginPostRouteOutput> get handler => AuthLoginPostRouteHandler.create(injector);

  @override
  String get path => '/login';

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;
}
