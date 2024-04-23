import 'package:transform/transform.dart';

class Produto2Model extends TransformModel {
  @override
  String get name => "produto2";

  @override
  String get schema => "public";

  @override
  List<TransformModelColumn> get columns => [
        TransformModelColumn(name: "id", type: TransformModelColumnTypeBigSerial(), isPrimaryKey: true, isNullable: false),
        TransformModelColumn(name: "nome", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "preco", type: TransformModelColumnTypeMonetary(), isNullable: true),
        TransformModelColumn(name: "quantidade", type: TransformModelColumnTypeInteger(), isNullable: true),
        TransformModelColumn(name: "vencimento", type: TransformModelColumnTypeTimeStamp(), isNullable: true),
        TransformModelColumn(name: "ativo", type: TransformModelColumnTypeBool(), isNullable: false, defaultValue: true),
        TransformModelColumn(name: "dimensoes", type: TransformModelColumnTypeJson(), isNullable: false, defaultValue: {}),
        TransformModelColumn(name: "cor", type: TransformModelColumnTypeText(), isNullable: true, defaultValue: '#FFFFFF'),
      ];

  @override
  List<TransformModelIndex> get indexes => [
        TransformModelIndex(name: "produto_nome", columnNames: ["nome"], isUnique: false),
      ];
}
