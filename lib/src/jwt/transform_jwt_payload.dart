import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TransformJWTPayload {
  final String userId;

  TransformJWTPayload({required this.userId});

  factory TransformJWTPayload.empty() {
    return TransformJWTPayload(userId: '');
  }

  factory TransformJWTPayload.fromJWT(JWT jwt) {
    return TransformJWTPayload(userId: jwt.payload['id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
    };
  }
}
