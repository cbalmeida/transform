import 'package:transform/transform.dart';

import '../../../generated/generated.dart';

class GetProdutoByIdUseCase extends TransformUseCase<User> {
  final ProdutoObject produtoObject;

  GetProdutoByIdUseCase({required this.produtoObject, required super.params});

  @override
  Future<TransformEither<Exception, Produto?>> call({required String id}) {
    return database.transaction<Exception, Produto?>((session) async {
      final select = produtoObject.databaseTable.select.where(produtoObject.databaseTable.columnByName('id').equals(id));
      final TransformEither<Exception, List<Produto>> result = await select.execute(session);
      if (result.isLeft) {
        await session.rollback();
        return Left(result.left);
      }
      return Right(result.right.firstOrNull);
    });
  }
}
