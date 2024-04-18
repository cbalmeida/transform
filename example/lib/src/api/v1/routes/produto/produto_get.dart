import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';

class ProdutoGetRouteInput extends TransformRouteInput {
  final String? id;
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
  Future<TransformRouteResponse<ProdutoGetRouteOutput>> handler(ProdutoGetRouteInput input) async {
    // verifica se todos os parametros foram informados
    if (input.id == null) return TransformRouteResponse.badRequest("'id' is required!");

    // abre uma transacao no banco de dados para efetuar a busca do produto
    TransformEither<Exception, Produto?> result = await Transform.instance.database.transaction<Produto?>((session) async {
      TransformEither<Exception, Produto?> result = await Transform.instance.produto.findUnique(session, where: {"id": input.id});
      return result;
    });

    //
    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    Produto? produto = result.right;

    if (produto == null) return TransformRouteResponse.notFound("id ${input.id} not found!");

    ProdutoGetRouteOutput output = ProdutoGetRouteOutput(id: produto.id, nome: produto.nome);
    return TransformRouteResponse.ok(output);
  }
}

class ProdutoGetRoute extends TransformRoute<ProdutoGetRouteInput, ProdutoGetRouteOutput> {
  ProdutoGetRoute()
      : super(
          method: TransformRouteMethod.get,
          path: '/produto/<id>',
          handler: ProdutoGetRouteHandler(),
        );
}
