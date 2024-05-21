import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../transform.dart';

enum TransformJWTType { hs256, rs256, es256, rsaCert }

abstract class TransformJWT {
  final TransformJWTParams params;
  TransformJWT({required this.params});

  TransformJWTAlgorithm get algorithm;

  TransformEither<Exception, String> generateToken(String userId) {
    TransformJWTPayload payload = TransformJWTPayload(userId: userId);
    final jwt = JWT(payload.toMap(), issuer: params.issuer);
    String result = algorithm.sign(jwt, expiresInSeconds: params.expiresInSeconds);
    return Right(result);
  }

  TransformEither<Exception, TransformJWTPayload> decodeToken(String token) {
    try {
      token = token.replaceAll("Bearer ", "");
      TransformEither<Exception, JWT> result = algorithm.verify(token);
      if (result.isLeft) return Left(result.left);
      JWT jwt = result.right;
      TransformJWTPayload payload = TransformJWTPayload.fromJWT(jwt);
      return Right(payload);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  static TransformJWT hs256(TransformJWTParamsHS256 params) => TransformJWTHS256(params: params);

  static TransformJWT rs256(TransformJWTParamsRS256 params) => TransformJWTRS256(params: params);

  static TransformJWT es256(TransformJWTParamsES256 params) => TransformJWTES256(params: params);

  static TransformJWT rsaCert(TransformJWTParamsRSACert params) => TransformJWTRSACert(params: params);

  static TransformJWT fromParams(TransformJWTParams params) {
    switch (params.type) {
      case TransformJWTType.hs256:
        return TransformJWT.hs256(params as TransformJWTParamsHS256);
      case TransformJWTType.rs256:
        return TransformJWT.rs256(params as TransformJWTParamsRS256);
      case TransformJWTType.es256:
        return TransformJWT.es256(params as TransformJWTParamsES256);
      case TransformJWTType.rsaCert:
        return TransformJWT.rsaCert(params as TransformJWTParamsRSACert);
    }
  }
}

class TransformJWTHS256 extends TransformJWT {
  TransformJWTHS256({required super.params});

  @override
  TransformJWTAlgorithm get algorithm => TransformJWTAlgorithmHS256(secretKey: params.privateKey);
}

class TransformJWTRS256 extends TransformJWT {
  TransformJWTRS256({required super.params});

  TransformJWTAlgorithm? _algorithm;

  @override
  TransformJWTAlgorithm get algorithm => _algorithm ??= TransformJWTAlgorithmRS256(privateKey: params.privateKey, publicKey: params.publicKey);
}

class TransformJWTES256 extends TransformJWT {
  TransformJWTES256({required super.params});

  TransformJWTAlgorithm? _algorithm;

  @override
  TransformJWTAlgorithm get algorithm => _algorithm ??= TransformJWTAlgorithmES256(privateKey: params.privateKey, publicKey: params.publicKey);
}

class TransformJWTRSACert extends TransformJWT {
  TransformJWTRSACert({required super.params});

  TransformJWTAlgorithm? _algorithm;

  @override
  TransformJWTAlgorithm get algorithm => _algorithm ??= TransformJWTAlgorithmRSACert(privateKey: params.privateKey, publicKey: params.publicKey);
}
