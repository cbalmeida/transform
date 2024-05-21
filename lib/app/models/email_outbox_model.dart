import 'package:transform/transform.dart';

class EmailOutboxModel extends TransformModel {
  @override
  String get name => "email_outbox";

  @override
  String get schema => "public";

  @override
  List<TransformModelColumn> get columns => [
        TransformModelColumn(name: "id", type: TransformModelColumnTypeBigSerial(), isPrimaryKey: true),
        TransformModelColumn(name: "status", type: TransformModelColumnTypeInteger(), isNullable: false, defaultValue: 0),
        TransformModelColumn(name: "sender", type: TransformModelColumnTypeJson(), isNullable: false, defaultValue: {}),
        TransformModelColumn(name: "recipients", type: TransformModelColumnTypeJson(), isNullable: true),
        TransformModelColumn(name: "cc_recipients", type: TransformModelColumnTypeJson(), isNullable: true),
        TransformModelColumn(name: "bcc_recipients", type: TransformModelColumnTypeJson(), isNullable: true),
        TransformModelColumn(name: "subject", type: TransformModelColumnTypeText(), isNullable: true),
        TransformModelColumn(name: "text_body", type: TransformModelColumnTypeText(), isNullable: true),
        TransformModelColumn(name: "html_body", type: TransformModelColumnTypeText(), isNullable: true),
        TransformModelColumn(name: "created_at", type: TransformModelColumnTypeTimeStamp(), isNullable: true),
        TransformModelColumn(name: "sent_at", type: TransformModelColumnTypeTimeStamp(), isNullable: true),
      ];

  @override
  List<TransformModelIndex> get indexes => [
        TransformModelIndex(name: "email_outbox_status", columnNames: ["status"], isUnique: false),
      ];
}
