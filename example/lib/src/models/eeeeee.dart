import 'package:transform/transform.dart';

class Produto3Model extends TransformModel {
  @override
  String get name => "produto1";

  @override
  String get schema => "public";

  @override
  List<TransformModelColumn> get columns => [
        TransformModelColumn(name: "id1111", type: TransformModelColumnTypeUUID(), isPrimaryKey: true, isNullable: false),
        TransformModelColumn(name: "nome1111", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "preco1111", type: TransformModelColumnTypeMonetary(), isNullable: true),
        TransformModelColumn(name: "quantidade1111", type: TransformModelColumnTypeInteger(), isNullable: true),
      ];

  @override
  List<TransformModelIndex> get indexes => [
        TransformModelIndex(name: "produto_nome", columnNames: ["nome"], isUnique: true),
      ];
}
