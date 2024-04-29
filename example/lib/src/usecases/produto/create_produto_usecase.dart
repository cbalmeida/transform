import 'package:transform/transform.dart';

import '../../../generated/generated.dart';

class CreateProdutoUseCase extends TransformUseCase<User> {
  final ProdutoObject produtoObject;

  CreateProdutoUseCase({required this.produtoObject, required super.database});

  @override
  Future<TransformEither<Exception, Produto>> call({
    required String? nome,
    required double? preco,
    required int? quantidade,
    required DateTime? vencimento,
    required bool? ativo,
    required Map<String, dynamic>? dimensoes,
  }) {
    return database.transaction<Produto>((session) async {
      Produto produto = Produto.create(nome: nome, preco: preco, quantidade: quantidade, vencimento: vencimento, ativo: ativo, dimensoes: dimensoes);
      final TransformEither<Exception, List<Produto>> response = await produtoObject.insert.values([produto]).execute(session);
      if (response.isLeft) {
        await session.rollback();
        return Left(response.left);
      }
      return Right(response.right.first);
    });
  }
}
