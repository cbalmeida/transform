import 'package:transform/transform.dart';

class User extends TransformMapped {
  final String? id;
  final String email;
  final String hashedPassword;
  final bool verified;
  final String verificationToken;
  final String verificationCode;
  final int verificationAttempts;

  @override
  List<String> get primaryKeyColumns => ['id'];

  User setVerified(bool verified) => copyWith(verified: verified);

  User setVerificationToken(String token) => copyWith(verificationToken: token);

  User setVerificationCode(String code) => copyWith(verificationCode: code);

  User increaseVerificationAttempts() => copyWith(verificationAttempts: verificationAttempts + 1);

  User resetVerificationAttempts() => copyWith(verificationAttempts: 0);

  User({
    required this.id,
    required this.email,
    required this.hashedPassword,
    required this.verified,
    required this.verificationToken,
    required this.verificationCode,
    required this.verificationAttempts,
  });

  factory User.fromEmailPassword(String email, String password, {bool verified = false, String verificationToken = '', String verificationCode = ''}) => User(
        id: null,
        email: email,
        hashedPassword: Util.hashPassword(password),
        verified: verified,
        verificationToken: verificationToken,
        verificationCode: verificationCode,
        verificationAttempts: 0,
      );

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map.valueString('id'),
      email: map.valueStringNotNull('email'),
      hashedPassword: map.valueStringNotNull('hashed_password'),
      verified: map.valueBoolNotNull('verified'),
      verificationToken: map.valueStringNotNull('verification_token'),
      verificationCode: map.valueStringNotNull('verification_code'),
      verificationAttempts: map.valueInt('verification_attempts') ?? 0,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? hashedPassword,
    bool? verified,
    String? verificationToken,
    String? verificationCode,
    int? verificationAttempts,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      verified: verified ?? this.verified,
      verificationToken: verificationToken ?? this.verificationToken,
      verificationCode: verificationCode ?? this.verificationCode,
      verificationAttempts: verificationAttempts ?? this.verificationAttempts,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'hashed_password': hashedPassword,
      'verified': verified,
      'verification_token': verificationToken,
      'verification_code': verificationCode,
      'verification_attempts': verificationAttempts,
    };
  }
}

class UserAdapter extends TransformModelAdapter<User> {
  @override
  User fromMap(Map<String, dynamic> map) => User.fromMap(map);

  @override
  Map<String, dynamic> toMap(User model) => model.toMap();
}

class UserObject extends TransformObject<User> {
  UserObject() : super(model: UserModel(), adapter: UserAdapter());

  TransformDatabaseColumn get id => model.columnByName('id');

  TransformDatabaseColumn get email => model.columnByName('email');

  TransformDatabaseColumn get hashedPassword => model.columnByName('hashed_password');
}
