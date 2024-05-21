import 'package:transform/transform.dart';

class AuthRegisterPostRouteInput extends TransformRouteInput {
  final String? email;
  final String? password;
  const AuthRegisterPostRouteInput({required this.email, required this.password});

  factory AuthRegisterPostRouteInput.fromMap(Map<String, dynamic> map) {
    return AuthRegisterPostRouteInput(email: map["email"], password: map["password"]);
  }
}

class AuthRegisterPostRouteOutput extends TransformRouteOutputJson {
  final String email;
  const AuthRegisterPostRouteOutput({required this.email});

  @override
  Map<String, dynamic> get output => {"email": email};
}

class AuthRegisterPostRouteHandler extends TransformRouteHandler<AuthRegisterPostRouteInput, AuthRegisterPostRouteOutput> {
  final AuthRegisterUseCase authRegisterUseCase;

  AuthRegisterPostRouteHandler({
    required super.jwt,
    required this.authRegisterUseCase,
    required super.limiter,
  });

  factory AuthRegisterPostRouteHandler.create(TransformInjector injector) {
    return AuthRegisterPostRouteHandler(
      jwt: injector.get(),
      authRegisterUseCase: injector.get(),
      limiter: injector.get(),
    );
  }

  @override
  AuthRegisterPostRouteInput inputFromParams(Map<String, dynamic> params) => AuthRegisterPostRouteInput.fromMap(params);

  @override
  bool get mustCheckToken => false;

  @override
  Future<TransformRouteResponse<AuthRegisterPostRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.email == null) return TransformRouteResponse.badRequest("Parameter 'email' not found");
    if (input.params.password == null) return TransformRouteResponse.badRequest("Parameter 'password' not found");

    TransformEither<AuthRegisterUseCaseException, AuthRegisterUseCaseResponse> result = await authRegisterUseCase(email: input.params.email!, password: input.params.password!);
    if (result.isLeft) {
      AuthRegisterUseCaseException exception = result.left;
      switch (exception.type) {
        case AuthRegisterUseCaseExceptionType.passwordTooShort:
          return TransformRouteResponse.badRequest("Parameter 'password' does not meet the criteria");
        case AuthRegisterUseCaseExceptionType.userAlreadyExists:
          return TransformRouteResponse.conflict("Email '${input.params.email}' already registered");
        case AuthRegisterUseCaseExceptionType.internalServerError:
          return TransformRouteResponse.internalServerError(exception);
      }
    }

    String email = result.right.email;
    AuthRegisterPostRouteOutput output = AuthRegisterPostRouteOutput(email: email);
    return TransformRouteResponse.ok(output);
  }
}

class AuthRegisterPostRoute extends TransformRoute<AuthRegisterPostRouteInput, AuthRegisterPostRouteOutput> {
  AuthRegisterPostRoute(super.injector);

  @override
  TransformRouteHandler<AuthRegisterPostRouteInput, AuthRegisterPostRouteOutput> get handler => AuthRegisterPostRouteHandler.create(injector);

  @override
  String get path => '/register';

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;
}
