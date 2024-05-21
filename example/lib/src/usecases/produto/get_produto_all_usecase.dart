import 'package:transform/transform.dart';

import '../../../generated/generated.dart';

class GetProdutoAllUseCase extends TransformUseCase<User> {
  final ProdutoObject produtoObject;

  GetProdutoAllUseCase({required this.produtoObject, required super.params});

  @override
  Future<TransformEither<Exception, List<Produto>>> call() {
    return database.transaction<Exception, List<Produto>>((session) async {
      final TransformEither<Exception, List<Produto>> response = await produtoObject.databaseTable.select.execute(session);
      if (response.isLeft) {
        await session.rollback();
        return Left(response.left);
      }
      return Right(response.right);
    });
  }
}
