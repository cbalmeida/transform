
import 'package:testeexemplo/src/models/tttttttt.dart';
import 'package:transform/transform.dart';

class Produto extends TransformMapped {
  Produto({required super.values});

  String get id => Util.stringFromMapNotNull(values, 'id', '');
  set id(String value) => values['id'] = value;

  String get nome => Util.stringFromMapNotNull(values, 'nome', '');
  set nome(String value) => values['nome'] = value;

  double? get preco => Util.doubleFromMap(values, 'preco');
  set preco(double? value) => values['preco'] = value;

  int? get quantidade => Util.intFromMap(values, 'quantidade');
  set quantidade(int? value) => values['quantidade'] = value;
}

class ProdutoAdapter extends TransformModelAdapter<Produto> {
  @override
  Produto fromMap(Map<String, dynamic> map) => Produto(values: map);

  @override
  Map<String, dynamic> toMap(Produto model) => model.values;
}

class ProdutoObject extends TransformObject<Produto> {
  ProdutoObject({required super.dataBase}) : super(model: ProdutoModel(), adapter: ProdutoAdapter());
}
