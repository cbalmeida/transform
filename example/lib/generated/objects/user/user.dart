import 'package:transform/transform.dart';

import '../../../src/models/user/user_model.dart';

class User extends TransformMapped {
  User({required super.values});

  String get id => Util.stringFromMapNotNull(values, 'id', '');
  set id(String value) => values['id'] = value;

  String get email => Util.stringFromMapNotNull(values, 'email', '');
  set email(String value) => values['email'] = value;

  String get hashedPassword => Util.stringFromMapNotNull(values, 'hashed_password', '');
  set hashedPassword(String value) => values['hashed_password'] = value;

  factory User.fromEmailPassword(String email, String password) => User(values: {
        "email": email,
        "hashed_password": Util.hashPassword(password),
      });
}

class UserAdapter extends TransformModelAdapter<User> {
  @override
  User fromMap(Map<String, dynamic> map) => User(values: map);

  @override
  Map<String, dynamic> toMap(User model) => model.values;
}

class UserObject extends TransformObject<User> {
  UserObject() : super(model: UserModel(), adapter: UserAdapter());

  TransformDatabaseColumn get id => model.columnByName('id');

  TransformDatabaseColumn get email => model.columnByName('email');

  TransformDatabaseColumn get hashedPassword => model.columnByName('hashed_password');
}
