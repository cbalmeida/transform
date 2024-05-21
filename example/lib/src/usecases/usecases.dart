import 'package:testeexemplo/src/usecases/produto/create_produto_usecase.dart';
import 'package:testeexemplo/src/usecases/produto/get_produto_all_usecase.dart';
import 'package:testeexemplo/src/usecases/produto/get_produto_by_id_usecase.dart';
import 'package:transform/transform.dart';

class UseCases extends TransformUseCases {
  @override
  void registerUseCases(TransformInjector injector) {
    // produto
    injector.add<CreateProdutoUseCase>(CreateProdutoUseCase.new);
    injector.add<GetProdutoAllUseCase>(GetProdutoAllUseCase.new);
    injector.add<GetProdutoByIdUseCase>(GetProdutoByIdUseCase.new);
  }
}
