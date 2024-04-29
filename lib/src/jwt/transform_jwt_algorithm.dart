import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:transform/src/jwt/transform_jwt_exception.dart';
import 'package:transform/src/transform/transform_either.dart';

abstract class TransformJWTAlgorithm {
  String sign(JWT jwt, {int? expiresInSeconds}) => jwt.sign(
        privateKey,
        algorithm: algorithm,
        expiresIn: expiresInSeconds != null ? Duration(seconds: expiresInSeconds) : null,
      );

  TransformEither<Exception, JWT> verify(String token) {
    try {
      final jwt = JWT.verify(token, publicKey);
      return Right(jwt);
    } on JWTExpiredException {
      throw TransformJWTExceptionExpired();
    } on JWTException catch (ex) {
      throw TransformJWTException(ex.message);
    }
  }

  JWTKey get privateKey;

  JWTKey get publicKey;

  JWTAlgorithm get algorithm;
}

class TransformJWTAlgorithmHS256 extends TransformJWTAlgorithm {
  final String secretKey;

  TransformJWTAlgorithmHS256({required this.secretKey});

  @override
  JWTAlgorithm get algorithm => JWTAlgorithm.HS256;

  @override
  JWTKey get privateKey => SecretKey(secretKey);

  @override
  JWTKey get publicKey => SecretKey(secretKey);
}

class TransformJWTAlgorithmRS256 extends TransformJWTAlgorithm {
  late final RSAPrivateKey _privateKey;
  late final RSAPublicKey _publicKey;

  TransformJWTAlgorithmRS256({required String privateKey, required String publicKey}) {
    _privateKey = RSAPrivateKey(privateKey);
    _publicKey = RSAPublicKey(publicKey);
  }

  @override
  JWTAlgorithm get algorithm => JWTAlgorithm.RS256;

  @override
  JWTKey get privateKey => _privateKey;

  @override
  JWTKey get publicKey => _publicKey;
}

class TransformJWTAlgorithmES256 extends TransformJWTAlgorithm {
  late final ECPrivateKey _privateKey;
  late final ECPublicKey _publicKey;

  TransformJWTAlgorithmES256({required String privateKey, required String publicKey}) {
    _privateKey = ECPrivateKey(privateKey);
    _publicKey = ECPublicKey(publicKey);
  }

  @override
  JWTAlgorithm get algorithm => JWTAlgorithm.ES256;

  @override
  JWTKey get privateKey => _privateKey;

  @override
  JWTKey get publicKey => _publicKey;
}

class TransformJWTAlgorithmRSACert extends TransformJWTAlgorithm {
  late final RSAPrivateKey _privateKey;
  late final RSAPublicKey _publicKey;

  TransformJWTAlgorithmRSACert({required String privateKey, required String publicKey}) {
    _privateKey = RSAPrivateKey(privateKey);
    _publicKey = RSAPublicKey.cert(publicKey);
  }

  @override
  JWTAlgorithm get algorithm => JWTAlgorithm.RS256;

  @override
  JWTKey get privateKey => _privateKey;

  @override
  JWTKey get publicKey => _publicKey;
}
