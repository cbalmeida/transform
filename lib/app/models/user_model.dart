import 'package:transform/transform.dart';

class UserModel extends TransformModel {
  @override
  String get name => "user";

  @override
  String get schema => "public";

  @override
  List<TransformModelColumn> get columns => [
        TransformModelColumn(name: "id", type: TransformModelColumnTypeBigSerial(), isPrimaryKey: true),
        TransformModelColumn(name: "email", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "hashed_password", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "verified", type: TransformModelColumnTypeBool(), isNullable: false, defaultValue: false.encodedValue),
        TransformModelColumn(name: "verification_token", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "verification_code", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "verification_attempts", type: TransformModelColumnTypeInteger()),
      ];

  @override
  List<TransformModelIndex> get indexes => [
        TransformModelIndex(name: "user_email", columnNames: ["email"], isUnique: true),
        TransformModelIndex(name: "user_verification_token", columnNames: ["verification_token"], isUnique: false),
      ];

  @override
  List<User> get initialData => [
        User.fromEmailPassword('admin@admin.com', 'admin', verified: true),
      ];
}
