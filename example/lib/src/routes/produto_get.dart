import 'dart:convert';

import 'package:transform/transform.dart';

import '../../generated/generated.dart';

class ProdutoGetRouteInput extends TransformRouteInput {
  final String id;
  ProdutoGetRouteInput({required this.id});

  factory ProdutoGetRouteInput.fromMap(Map<String, dynamic> map) {
    return ProdutoGetRouteInput(id: map["id"]);
  }
}

class ProdutoGetRouteOutput extends TransformRouteOutput {
  final String id;
  final String nome;
  ProdutoGetRouteOutput({required this.id, required this.nome});

  @override
  String toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "nome": nome,
    };
    return jsonEncode(map);
  }
}

class ProdutoGetRouteHandler extends TransformRouteHandler<ProdutoGetRouteInput, ProdutoGetRouteOutput> {
  @override
  Future<TransformRouteResponse<ProdutoGetRouteOutput>> execute(ProdutoGetRouteInput input) async {
    Produto? produto = await Transform.instance.produto.findUnique(where: {"id": input.id});

    // se nao encontrar o produto, retorna 404 Not Found
    if (produto == null) return TransformRouteResponse.notFound({"id": input.id});

    // se encontrar o produto, retorna 200 OK
    ProdutoGetRouteOutput output = ProdutoGetRouteOutput(id: produto.id, nome: produto.nome);
    return TransformRouteResponse.ok(output);
  }

  @override
  ProdutoGetRouteInput inputFromValues(Map<String, dynamic> values) => ProdutoGetRouteInput.fromMap(values);
}

class ProdutoGetRoute extends TransformRoute<ProdutoGetRouteInput, ProdutoGetRouteOutput> {
  ProdutoGetRoute()
      : super(
          method: TransformRouteMethod.get,
          path: '/produto',
          handler: ProdutoGetRouteHandler(),
        );
}
