import 'package:transform/transform.dart';

import '../../../generated/generated.dart';

class CreateProdutoUseCase extends TransformUseCase<User> {
  final ProdutoObject produtoObject;

  CreateProdutoUseCase({required this.produtoObject, required super.params});

  @override
  Future<TransformEither<Exception, Produto>> call({
    required String? nome,
    required double? preco,
    required int? quantidade,
    required DateTime? vencimento,
    required bool? ativo,
    required Map<String, dynamic>? dimensoes,
  }) {
    return database.transaction<Exception, Produto>((session) async {
      Produto produto = Produto(id: '', nome: nome ?? '', preco: preco, quantidade: quantidade, vencimento: vencimento, ativo: ativo ?? false, dimensoes: dimensoes ?? {});
      final TransformEither<Exception, List<Produto>> response = await produtoObject.databaseTable.insert.values(produto).execute(session);
      if (response.isLeft) {
        await session.rollback();
        return Left(response.left);
      }
      return Right(response.right.first);
    });
  }
}
