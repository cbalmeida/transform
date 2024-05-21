import 'package:transform/transform.dart';

import '../../../../../generated/generated.dart';
import '../../../usecases/produto/create_produto_usecase.dart';

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
  Map<String, dynamic> get output => produto.toMap();
}

class PostProdutoRouteHandler extends TransformRouteHandler<PostProdutoRouteInput, PostProdutoRouteOutput> {
  final CreateProdutoUseCase createProdutoUseCase;

  PostProdutoRouteHandler({required super.jwt, required this.createProdutoUseCase, required super.limiter});

  factory PostProdutoRouteHandler.create(TransformInjector injector) {
    return PostProdutoRouteHandler(
      jwt: injector.get(),
      createProdutoUseCase: injector.get(),
      limiter: injector.get(),
    );
  }

  @override
  PostProdutoRouteInput inputFromParams(Map<String, dynamic> params) => PostProdutoRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<PostProdutoRouteOutput>> handler(TransformRouteHandlerInputs input) async {
    if (input.params.nome == null) return TransformRouteResponse.badRequest("'nome' is required!");

    TransformEither<Exception, Produto> result = await createProdutoUseCase(
      nome: input.params.nome,
      preco: input.params.preco,
      quantidade: input.params.quantidade,
      vencimento: input.params.vencimento,
      ativo: input.params.ativo,
      dimensoes: input.params.dimensoes,
    );

    if (result.isLeft) return TransformRouteResponse.internalServerError(result.left);
    Produto produto = result.right;

    PostProdutoRouteOutput output = PostProdutoRouteOutput(produto: produto);
    return TransformRouteResponse.ok(output);
  }
}

class PostProdutoRoute extends TransformRoute<PostProdutoRouteInput, PostProdutoRouteOutput> {
  PostProdutoRoute(super.injector);

  @override
  TransformRouteHandler<PostProdutoRouteInput, PostProdutoRouteOutput> get handler => PostProdutoRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.post;

  @override
  String get path => '/produto';
}
