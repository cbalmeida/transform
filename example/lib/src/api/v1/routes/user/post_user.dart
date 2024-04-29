import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';
import '../../../../usecases/user/create_user_usecase.dart';

class PostUserRouteInput extends TransformRouteInput {
  final String? email;
  final String? password;

  const PostUserRouteInput({required this.email, required this.password});

  factory PostUserRouteInput.fromMap(Map<String, dynamic> map) {
    return PostUserRouteInput(
      email: map["email"],
      password: map["password"],
    );
  }

  Map<String, dynamic> get values => {
        "email": email,
        "password": password,
      };
}

class PostUserRouteOutput extends TransformRouteOutputJson {
  final User user;
  const PostUserRouteOutput({required this.user});

  @override
  Map<String, dynamic> get output => user.values;
}

class PostUserRouteHandler extends TransformRouteHandler<PostUserRouteInput, PostUserRouteOutput> {
  final CreateUserUseCase createUserUseCase;

  PostUserRouteHandler({required this.createUserUseCase, required super.jwt});

  factory PostUserRouteHandler.create(TransformInjector injector) {
    return PostUserRouteHandler(
      createUserUseCase: injector.get(),
      jwt: injector.get(),
    );
  }

  @override
  PostUserRouteInput inputFromParams(Map<String, dynamic> params) => PostUserRouteInput.fromMap(params);

  @override
  TransformEither<Exception, TransformJWTPayload> decodeToken(String token) => Right(TransformJWTPayload(userId: ''));

  @override
  Future<TransformRouteResponse<PostUserRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    // verifica se todos os parametros foram informados
    if (input.params.email == null) return TransformRouteResponse.badRequest("'email' is required!");
    if (input.params.password == null) return TransformRouteResponse.badRequest("'password' is required!");

    TransformEither<Exception, User> result = await createUserUseCase(email: input.params.email!, password: input.params.password!);

    // se houve algum erro na transacao, retorna um erro interno
    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);

    // retorna o usuario gravado
    PostUserRouteOutput output = PostUserRouteOutput(user: result.right);
    return TransformRouteResponse.ok(output);
  }
}

class PostUserRoute extends TransformRoute<PostUserRouteInput, PostUserRouteOutput> {
  PostUserRoute(super.injector);

  @override
  TransformRouteHandler<PostUserRouteInput, PostUserRouteOutput> get handler => PostUserRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;

  @override
  String get path => '/produto';
}
