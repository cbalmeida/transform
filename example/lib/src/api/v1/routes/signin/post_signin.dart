import 'package:transform/transform.dart';

import '../../../../usecases/user/signin_user_usecase.dart';

class PostSignInRouteInput extends TransformRouteInput {
  final String? email;
  final String? password;
  const PostSignInRouteInput({required this.email, required this.password});

  factory PostSignInRouteInput.fromMap(Map<String, dynamic> map) {
    return PostSignInRouteInput(email: map["email"], password: map["password"]);
  }
}

class PostSignInRouteOutput extends TransformRouteOutputJson {
  final String token;
  const PostSignInRouteOutput({required this.token});

  @override
  Map<String, dynamic> get output => {"token": token};
}

class PostSignInRouteHandler extends TransformRouteHandler<PostSignInRouteInput, PostSignInRouteOutput> {
  final SigninUserUseCase signinUserUseCase;

  PostSignInRouteHandler({required super.jwt, required this.signinUserUseCase});

  factory PostSignInRouteHandler.create(TransformInjector injector) {
    return PostSignInRouteHandler(
      jwt: injector.get(),
      signinUserUseCase: injector.get(),
    );
  }

  @override
  PostSignInRouteInput inputFromParams(Map<String, dynamic> params) => PostSignInRouteInput.fromMap(params);

  @override
  bool get checkToken => false;

  @override
  Future<TransformRouteResponse<PostSignInRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.email == null) return TransformRouteResponse.badRequest("'email' is required!");
    if (input.params.password == null) return TransformRouteResponse.badRequest("'password' is required!");

    TransformEither<Exception, String> result = await signinUserUseCase(email: input.params.email!, password: input.params.password!);
    if (result.isLeft) {
      if (result.left is SigninUserUseCaseExceptionUserNotFound) return TransformRouteResponse.unauthorized("User not found");
      if (result.left is SigninUserUseCaseExceptionInvalidPassword) return TransformRouteResponse.unauthorized("Invalid password");
      return TransformRouteResponse.internalServerError(result.left);
    }

    String token = result.right;
    PostSignInRouteOutput output = PostSignInRouteOutput(token: token);
    return TransformRouteResponse.ok(output);
  }
}

class PostSignInRoute extends TransformRoute<PostSignInRouteInput, PostSignInRouteOutput> {
  PostSignInRoute(super.injector);

  @override
  TransformRouteHandler<PostSignInRouteInput, PostSignInRouteOutput> get handler => PostSignInRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;

  @override
  String get path => '/signin';
}
