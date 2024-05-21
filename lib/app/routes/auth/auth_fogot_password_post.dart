import 'package:transform/transform.dart';

class AuthForgotPasswordPostRouteInput extends TransformRouteInput {
  final String? email;
  final String? password;
  const AuthForgotPasswordPostRouteInput({required this.email, required this.password});

  factory AuthForgotPasswordPostRouteInput.fromMap(Map<String, dynamic> map) {
    return AuthForgotPasswordPostRouteInput(email: map["email"], password: map["password"]);
  }
}

class AuthForgotPasswordPostRouteOutput extends TransformRouteOutputJson {
  final String email;
  const AuthForgotPasswordPostRouteOutput({required this.email});

  @override
  Map<String, dynamic> get output => {"email": email};
}

class AuthForgotPasswordPostRouteHandler extends TransformRouteHandler<AuthForgotPasswordPostRouteInput, AuthForgotPasswordPostRouteOutput> {
  final AuthForgotPasswordUseCase authForgotPasswordUseCase;

  AuthForgotPasswordPostRouteHandler({
    required super.jwt,
    required this.authForgotPasswordUseCase,
    required super.limiter,
  });

  factory AuthForgotPasswordPostRouteHandler.create(TransformInjector injector) {
    return AuthForgotPasswordPostRouteHandler(
      jwt: injector.get(),
      authForgotPasswordUseCase: injector.get(),
      limiter: injector.get(),
    );
  }

  @override
  AuthForgotPasswordPostRouteInput inputFromParams(Map<String, dynamic> params) => AuthForgotPasswordPostRouteInput.fromMap(params);

  @override
  bool get mustCheckToken => false;

  @override
  Future<TransformRouteResponse<AuthForgotPasswordPostRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.email == null) return TransformRouteResponse.badRequest("Parameter 'email' not found");

    TransformEither<AuthForgotPasswordUseCaseException, AuthForgotPasswordUseCaseResponse> result = await authForgotPasswordUseCase(email: input.params.email!);
    if (result.isLeft) {
      AuthForgotPasswordUseCaseException exception = result.left;
      switch (exception.type) {
        case AuthForgotPasswordUseCaseExceptionType.userNotFound:
          return TransformRouteResponse.badRequest("Email '${input.params.email}' not found");
        case AuthForgotPasswordUseCaseExceptionType.internalServerError:
          return TransformRouteResponse.internalServerError(exception);
      }
    }

    String email = result.right.email;
    AuthForgotPasswordPostRouteOutput output = AuthForgotPasswordPostRouteOutput(email: email);
    return TransformRouteResponse.ok(output);
  }
}

class AuthForgotPasswordPostRoute extends TransformRoute<AuthForgotPasswordPostRouteInput, AuthForgotPasswordPostRouteOutput> {
  AuthForgotPasswordPostRoute(super.injector);

  @override
  TransformRouteHandler<AuthForgotPasswordPostRouteInput, AuthForgotPasswordPostRouteOutput> get handler => AuthForgotPasswordPostRouteHandler.create(injector);

  @override
  String get path => '/forgot-password';

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;
}
