import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';
import '../../../../usecases/produto/get_produto_by_id_usecase.dart';

class GetProdutoByIdRouteInput extends TransformRouteInput {
  final String? id;
  const GetProdutoByIdRouteInput({required this.id});

  factory GetProdutoByIdRouteInput.fromMap(Map<String, dynamic> map) {
    return GetProdutoByIdRouteInput(id: map["id"]);
  }
}

class GetProdutoByIdRouteOutput extends TransformRouteOutputJson {
  final Produto produto;
  const GetProdutoByIdRouteOutput({required this.produto});

  @override
  Map<String, dynamic> get output => produto.values;
}

class GetProdutoByIdRouteHandler extends TransformRouteHandler<GetProdutoByIdRouteInput, GetProdutoByIdRouteOutput> {
  final GetProdutoByIdUseCase getProdutoByIdUseCase;

  GetProdutoByIdRouteHandler({required super.jwt, required this.getProdutoByIdUseCase});

  factory GetProdutoByIdRouteHandler.create(TransformInjector injector) {
    return GetProdutoByIdRouteHandler(
      getProdutoByIdUseCase: injector.get(),
      jwt: injector.get(),
    );
  }

  @override
  GetProdutoByIdRouteInput inputFromParams(Map<String, dynamic> params) => GetProdutoByIdRouteInput.fromMap(params);

  @override
  bool get checkToken => false;

  @override
  Future<TransformRouteResponse<GetProdutoByIdRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.id == null) return TransformRouteResponse.badRequest("'id' is required!");
    String id = input.params.id!;

    TransformEither<Exception, Produto?> result = await getProdutoByIdUseCase(id: id);

    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    Produto? produto = result.right;

    if (produto == null) return TransformRouteResponse.notFound("id $id not found!");

    GetProdutoByIdRouteOutput output = GetProdutoByIdRouteOutput(produto: produto);
    return TransformRouteResponse.ok(output);
  }
}

class GetProdutoByIdRoute extends TransformRoute<GetProdutoByIdRouteInput, GetProdutoByIdRouteOutput> {
  GetProdutoByIdRoute(super.injector);

  @override
  TransformRouteHandler<GetProdutoByIdRouteInput, GetProdutoByIdRouteOutput> get handler => GetProdutoByIdRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.get;

  @override
  String get path => '/produto/<id>';
}
