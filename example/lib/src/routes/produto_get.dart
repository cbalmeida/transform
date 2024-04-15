import 'package:transform/transform.dart';

import '../../generated/generated.dart';

class ProdutoGetRouteInput extends TransformRouteInput {
  final String id;
  const ProdutoGetRouteInput({required this.id});

  factory ProdutoGetRouteInput.fromMap(Map<String, dynamic> map) {
    return ProdutoGetRouteInput(id: map["id"]);
  }
}

class ProdutoGetRouteOutput extends TransformRouteOutput {
  final String id;
  final String nome;
  const ProdutoGetRouteOutput({required this.id, required this.nome});

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
      };
}

class ProdutoGetRouteHandler extends TransformRouteHandler<ProdutoGetRouteInput, ProdutoGetRouteOutput> {
  @override
  ProdutoGetRouteInput inputFromParams(Map<String, dynamic> params) => ProdutoGetRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<ProdutoGetRouteOutput>> execute(ProdutoGetRouteInput input) async {
    TransformEither<Exception, Produto?> result = await Transform.instance.produto.findUnique(where: {"id": input.id});

    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    Produto? produto = result.right;

    // se nao encontrar o produto, retorna 404 Not Found
    if (produto == null) return TransformRouteResponse.notFound({"id": input.id});

    // se encontrar o produto, retorna 200 OK
    ProdutoGetRouteOutput output = ProdutoGetRouteOutput(id: produto.id, nome: produto.nome);
    return TransformRouteResponse.ok(output);
  }
}

class ProdutoGetRoute extends TransformRoute<ProdutoGetRouteInput, ProdutoGetRouteOutput> {
  ProdutoGetRoute()
      : super(
          method: TransformRouteMethod.get,
          path: '/produto',
          handler: ProdutoGetRouteHandler(),
        );
}
