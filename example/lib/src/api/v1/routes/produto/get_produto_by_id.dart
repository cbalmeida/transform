import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';

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
  @override
  GetProdutoByIdRouteInput inputFromParams(Map<String, dynamic> params) => GetProdutoByIdRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<GetProdutoByIdRouteOutput>> handler(GetProdutoByIdRouteInput input) async {
    // verifica se todos os parametros foram informados
    if (input.id == null) return TransformRouteResponse.badRequest("'id' is required!");

    // abre uma transacao no banco de dados para efetuar a busca do produto
    TransformEither<Exception, Produto?> result = await Transform.instance.database.transaction<Produto?>((session) async {
      TransformEither<Exception, List<Produto>> result = await Transform.instance.produto.select.where({"id": input.id}).execute(session);
      return result.fold((value) => Left(value), (value) => Right(value.firstOrNull));
    });

    // se ocorreu um erro ao buscar o produto, retorna um erro interno
    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    Produto? produto = result.right;

    // se o produto nao foi encontrado, retorna um erro 404
    if (produto == null) return TransformRouteResponse.notFound("id ${input.id} not found!");

    // retorna o produto encontrado
    GetProdutoByIdRouteOutput output = GetProdutoByIdRouteOutput(produto: produto);
    return TransformRouteResponse.ok(output);
  }
}

class GetProdutoByIdRoute extends TransformRoute<GetProdutoByIdRouteInput, GetProdutoByIdRouteOutput> {
  GetProdutoByIdRoute()
      : super(
          method: TransformRouteMethod.get,
          path: '/produto/<id>',
          handler: GetProdutoByIdRouteHandler(),
        );
}
