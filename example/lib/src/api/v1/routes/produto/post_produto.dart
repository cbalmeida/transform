import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';

class PostProdutoRouteInput extends TransformRouteInput {
  final String? nome;
  final double? preco;
  final int? quantidade;
  final DateTime? vencimento;
  final bool? ativo;
  final Map<String, dynamic>? dimensoes;

  const PostProdutoRouteInput({required this.nome, required this.preco, required this.quantidade, required this.vencimento, required this.ativo, required this.dimensoes});

  factory PostProdutoRouteInput.fromMap(Map<String, dynamic> map) {
    return PostProdutoRouteInput(
      nome: map["nome"],
      preco: map["preco"],
      quantidade: map["quantidade"],
      vencimento: map["vencimento"],
      ativo: map["ativo"],
      dimensoes: map["dimensoes"],
    );
  }

  Map<String, dynamic> get values => {
        "nome": nome,
        "preco": preco,
        "quantidade": quantidade,
        "vencimento": vencimento,
        "ativo": ativo,
        "dimensoes": dimensoes,
      };
}

class PostProdutoRouteOutput extends TransformRouteOutputJson {
  final Produto produto;
  const PostProdutoRouteOutput({required this.produto});

  @override
  Map<String, dynamic> get output => produto.values;
}

class PostProdutoRouteHandler extends TransformRouteHandler<PostProdutoRouteInput, PostProdutoRouteOutput> {
  @override
  PostProdutoRouteInput inputFromParams(Map<String, dynamic> params) => PostProdutoRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<PostProdutoRouteOutput>> handler(PostProdutoRouteInput input) async {
    // verifica se todos os parametros foram informados
    if (input.nome == null) return TransformRouteResponse.badRequest("'nome' is required!");

    // abre uma transacao no banco de dados para efetuar a gravacao do produto
    TransformEither<Exception, Produto> result = await Transform.instance.database.transaction<Produto>((session) async {
      Produto produto = Produto(values: input.values);
      TransformEither<Exception, List<Produto>> result = await Transform.instance.produto.insert.values([produto]).execute(session);
      return result.fold((value) => Left(value), (value) => Right(value.first));
    });

    // se houve algum erro na transacao, retorna um erro interno
    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    Produto produto = result.right;

    // retorna o produto gravado
    PostProdutoRouteOutput output = PostProdutoRouteOutput(produto: produto);
    return TransformRouteResponse.ok(output);
  }
}

class PostProdutoRoute extends TransformRoute<PostProdutoRouteInput, PostProdutoRouteOutput> {
  PostProdutoRoute()
      : super(
          method: TransformRouteMethod.post,
          path: '/produto',
          handler: PostProdutoRouteHandler(),
        );
}
