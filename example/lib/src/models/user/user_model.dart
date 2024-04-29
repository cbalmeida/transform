import 'package:transform/transform.dart';

import '../../../generated/objects/user/user.dart';

class UserModel extends TransformModel {
  @override
  String get name => "user";

  @override
  String get schema => "public";

  @override
  List<TransformModelColumn> get columns => [
        TransformModelColumn(name: "id", type: TransformModelColumnTypeBigSerial(), isPrimaryKey: true, isNullable: false),
        TransformModelColumn(name: "email", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
        TransformModelColumn(name: "hashed_password", type: TransformModelColumnTypeText(), isNullable: false, defaultValue: ""),
      ];

  @override
  List<TransformModelIndex> get indexes => [
        TransformModelIndex(name: "user_email", columnNames: ["email"], isUnique: false),
      ];

  @override
  List<User> get initialData => [
        User.fromEmailPassword('admin@admin.com', 'admin'),
      ];
}
