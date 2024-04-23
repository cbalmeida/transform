import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';

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
  @override
  GetProdutoAllRouteInput inputFromParams(Map<String, dynamic> params) => GetProdutoAllRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<GetProdutoAllRouteOutput>> handler(GetProdutoAllRouteInput input) async {
    // abre uma transacao no banco de dados para efetuar a busca do produto
    TransformEither<Exception, List<Produto>> result = await Transform.instance.database.transaction<List<Produto>>((session) async {
      TransformEither<Exception, List<Produto>> result = await Transform.instance.produto.select.all().execute(session);
      return result.fold((value) => Left(value), (value) => Right(value));
    });

    // se ocorreu um erro ao buscar o produto, retorna um erro interno
    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    List<Produto> produtos = result.right;

    // retorna o produto encontrado
    GetProdutoAllRouteOutput output = GetProdutoAllRouteOutput(produtos: produtos);
    return TransformRouteResponse.ok(output);
  }
}

class GetProdutoAllRoute extends TransformRoute<GetProdutoAllRouteInput, GetProdutoAllRouteOutput> {
  GetProdutoAllRoute()
      : super(
          method: TransformRouteMethod.get,
          path: '/produto',
          handler: GetProdutoAllRouteHandler(),
        );
}
