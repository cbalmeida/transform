import 'package:transform/transform.dart';

import '../../../src/models/produto/produto_model.dart';

class Produto extends TransformMapped {
  final String id;
  final String nome;
  final double? preco;
  final int? quantidade;
  final DateTime? vencimento;
  final bool ativo;
  final Map<String, dynamic> dimensoes;

  @override
  List<String> get primaryKeyColumns => ['id'];

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.quantidade,
    required this.vencimento,
    required this.ativo,
    required this.dimensoes,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map.valueStringNotNull('id'),
      nome: map.valueStringNotNull('nome'),
      preco: map.valueDouble('preco'),
      quantidade: map.valueInt('quantidade'),
      vencimento: map.valueDateTime('vencimento'),
      ativo: map.valueBoolNotNull('ativo'),
      dimensoes: map.valueMapNotNull('dimensoes'),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
      'vencimento': vencimento,
      'ativo': ativo,
      'dimensoes': dimensoes,
    };
  }
}

class ProdutoAdapter extends TransformModelAdapter<Produto> {
  @override
  Produto fromMap(Map<String, dynamic> map) => Produto.fromMap(map);

  @override
  Map<String, dynamic> toMap(Produto model) => model.toMap();
}

class ProdutoObject extends TransformObject<Produto> {
  ProdutoObject() : super(model: ProdutoModel(), adapter: ProdutoAdapter());
}
