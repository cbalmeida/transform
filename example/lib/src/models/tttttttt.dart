import 'package:transform/transform.dart';

class ProdutoModel extends TransformModel {
  @override
  String get name => "produto3";

  @override
  String get schema => "public";

  @override
  List<TransformModelColumn> get columns => [
        TransformModelColumn(name: "id222", type: TransformModelColumnTypeUUID(), isPrimaryKey: true, isNullable: false),
        TransformModelColumn(name: "nome222", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "preco22222", type: TransformModelColumnTypeMonetary(), isNullable: true),
        TransformModelColumn(name: "quantidade2222", type: TransformModelColumnTypeInteger(), isNullable: true),
      ];

  @override
  List<TransformModelIndex> get indexes => [
        TransformModelIndex(name: "produto_nome", columnNames: ["nome"], isUnique: true),
      ];
}
