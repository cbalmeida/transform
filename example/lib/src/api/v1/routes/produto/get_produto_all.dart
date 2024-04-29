import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';
import '../../../../usecases/produto/get_produto_all_usecase.dart';

class GetProdutoAllRouteInput extends TransformRouteInput {
  const GetProdutoAllRouteInput();

  factory GetProdutoAllRouteInput.fromMap(Map<String, dynamic> map) {
    return GetProdutoAllRouteInput();
  }
}

class GetProdutoAllRouteOutput extends TransformRouteOutputJson {
  final List<Produto> produtos;
  const GetProdutoAllRouteOutput({required this.produtos});

  @override
  Map<String, dynamic> get output => {"produtos": produtos.map((e) => e.values).toList()};
}

class GetProdutoAllRouteHandler extends TransformRouteHandler<GetProdutoAllRouteInput, GetProdutoAllRouteOutput> {
  final GetProdutoAllUseCase getProdutoAllUseCase;

  GetProdutoAllRouteHandler({required this.getProdutoAllUseCase, required super.jwt});

  factory GetProdutoAllRouteHandler.create(TransformInjector injector) {
    return GetProdutoAllRouteHandler(
      getProdutoAllUseCase: injector.get(),
      jwt: injector.get(),
    );
  }

  @override
  GetProdutoAllRouteInput inputFromParams(Map<String, dynamic> params) => GetProdutoAllRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<GetProdutoAllRouteOutput>> handler(GetProdutoAllRouteInput input, TransformJWTPayload tokenPayload) async {
    TransformEither<Exception, List<Produto>> result = await getProdutoAllUseCase();

    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    List<Produto> produtos = result.right;

    GetProdutoAllRouteOutput output = GetProdutoAllRouteOutput(produtos: produtos);
    return TransformRouteResponse.ok(output);
  }
}

class GetProdutoAllRoute extends TransformRoute<GetProdutoAllRouteInput, GetProdutoAllRouteOutput> {
  GetProdutoAllRoute(super.injector);

  @override
  TransformRouteHandler<GetProdutoAllRouteInput, GetProdutoAllRouteOutput> get handler => GetProdutoAllRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.get;

  @override
  String get path => '/produto';
}
