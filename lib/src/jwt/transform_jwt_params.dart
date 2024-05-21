import 'dart:io';

import 'package:yaml/yaml.dart';

import '../../transform.dart';

abstract class TransformJWTParams {
  final int expiresInSeconds;
  final String issuer;
  final String privateKey;
  final String publicKey;

  TransformJWTParams({required this.expiresInSeconds, required this.issuer, required this.privateKey, required this.publicKey});

  TransformJWTType get type;

  static TransformJWTParamsBuilderHS256 hs256 = TransformJWTParamsBuilderHS256();

  static TransformJWTParamsBuilderRS256 rs256 = TransformJWTParamsBuilderRS256();

  static TransformJWTParamsBuilderES256 es256 = TransformJWTParamsBuilderES256();

  static TransformJWTParamsBuilderRSACert rsaCert = TransformJWTParamsBuilderRSACert();

  static TransformJWTParams fromParams(TransformJWTParams params) {
    switch (params.type) {
      case TransformJWTType.hs256:
        return TransformJWTParamsHS256.fromParams(params);
      case TransformJWTType.rs256:
        return TransformJWTParamsRS256.fromParams(params);
      case TransformJWTType.es256:
        return TransformJWTParamsES256.fromParams(params);
      case TransformJWTType.rsaCert:
        return TransformJWTParamsRSACert.fromParams(params);
    }
  }
}

// HS256

class TransformJWTParamsBuilderHS256 {
  TransformJWTParamsHS256 fromMap(Map<String, dynamic> map) => TransformJWTParamsHS256.fromMap(map);

  TransformJWTParamsHS256 fromEnvironment() => TransformJWTParamsHS256.fromEnvironment();

  TransformJWTParamsHS256 fromFiles() => TransformJWTParamsHS256.fromEnvironment();

  TransformJWTParamsHS256 fromValues({required int expiresInSeconds, required String issuer, required String privateKey, required String publicKey}) => TransformJWTParamsHS256(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
}

class TransformJWTParamsHS256 extends TransformJWTParams {
  TransformJWTParamsHS256({required super.expiresInSeconds, required super.issuer, required super.privateKey, required super.publicKey});

  @override
  TransformJWTType get type => TransformJWTType.hs256;

  factory TransformJWTParamsHS256.fromParams(TransformJWTParams params) => TransformJWTParamsHS256(
        expiresInSeconds: params.expiresInSeconds,
        issuer: params.issuer,
        privateKey: params.privateKey,
        publicKey: params.publicKey,
      );

  factory TransformJWTParamsHS256.fromEnvironment() => TransformJWTParamsHS256(
        expiresInSeconds: const int.fromEnvironment('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: const String.fromEnvironment('JWT_ISSUER', defaultValue: ''),
        privateKey: const String.fromEnvironment('JWT_PRIVATE_KEY', defaultValue: ''),
        publicKey: const String.fromEnvironment('JWT_PUBLIC_KEY', defaultValue: ''),
      );

  factory TransformJWTParamsHS256.fromMap(Map<String, dynamic> map) => TransformJWTParamsHS256(
        expiresInSeconds: map.valueIntNotNull('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: map.valueStringNotNull('JWT_ISSUER'),
        privateKey: map.valueStringNotNull('JWT_PRIVATE_KEY'),
        publicKey: map.valueStringNotNull('JWT_PUBLIC_KEY'),
      );

  factory TransformJWTParamsHS256.fromFiles() {
    var yaml = loadYaml(File('jwt/jwt.yaml').readAsStringSync()) as Map;
    final int expiresInSeconds = yaml['expiresInSeconds'] as int;
    final String issuer = yaml['issuer'] as String;
    final privateKey = File('jwt/hs256/private_key.pem').readAsStringSync();
    final publicKey = privateKey;
    return TransformJWTParamsHS256(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
  }
}

// RS256

class TransformJWTParamsBuilderRS256 {
  TransformJWTParamsRS256 fromMap(Map<String, dynamic> map) => TransformJWTParamsRS256.fromMap(map);

  TransformJWTParamsRS256 fromEnvironment() => TransformJWTParamsRS256.fromEnvironment();

  TransformJWTParamsRS256 fromFiles() => TransformJWTParamsRS256.fromEnvironment();

  TransformJWTParamsRS256 fromValues({required int expiresInSeconds, required String issuer, required String privateKey, required String publicKey}) => TransformJWTParamsRS256(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
}

class TransformJWTParamsRS256 extends TransformJWTParams {
  TransformJWTParamsRS256({required super.expiresInSeconds, required super.issuer, required super.privateKey, required super.publicKey});

  @override
  TransformJWTType get type => TransformJWTType.rs256;

  factory TransformJWTParamsRS256.fromParams(TransformJWTParams params) => TransformJWTParamsRS256(
        expiresInSeconds: params.expiresInSeconds,
        issuer: params.issuer,
        privateKey: params.privateKey,
        publicKey: params.publicKey,
      );

  factory TransformJWTParamsRS256.fromEnvironment() => TransformJWTParamsRS256(
        expiresInSeconds: const int.fromEnvironment('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: const String.fromEnvironment('JWT_ISSUER', defaultValue: ''),
        privateKey: const String.fromEnvironment('JWT_PRIVATE_KEY', defaultValue: ''),
        publicKey: const String.fromEnvironment('JWT_PUBLIC_KEY', defaultValue: ''),
      );

  factory TransformJWTParamsRS256.fromMap(Map<String, dynamic> map) => TransformJWTParamsRS256(
        expiresInSeconds: map.valueIntNotNull('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: map.valueStringNotNull('JWT_ISSUER'),
        privateKey: map.valueStringNotNull('JWT_PRIVATE_KEY'),
        publicKey: map.valueStringNotNull('JWT_PUBLIC_KEY'),
      );

  factory TransformJWTParamsRS256.fromFiles() {
    var yaml = loadYaml(File('jwt/jwt.yaml').readAsStringSync()) as Map;
    final int expiresInSeconds = yaml['expiresInSeconds'] as int;
    final String issuer = yaml['issuer'] as String;
    final privateKey = File('jwt/rs256/private_key.pem').readAsStringSync();
    final publicKey = File('jwt/rs256/public_key.pem').readAsStringSync();
    return TransformJWTParamsRS256(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
  }
}

// ES256

class TransformJWTParamsBuilderES256 {
  TransformJWTParamsES256 fromMap(Map<String, dynamic> map) => TransformJWTParamsES256.fromMap(map);

  TransformJWTParamsES256 fromEnvironment() => TransformJWTParamsES256.fromEnvironment();

  TransformJWTParamsES256 fromFiles() => TransformJWTParamsES256.fromFiles();

  TransformJWTParamsES256 fromValues({required int expiresInSeconds, required String issuer, required String privateKey, required String publicKey}) => TransformJWTParamsES256(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
}

class TransformJWTParamsES256 extends TransformJWTParams {
  TransformJWTParamsES256({required super.expiresInSeconds, required super.issuer, required super.privateKey, required super.publicKey});

  @override
  TransformJWTType get type => TransformJWTType.es256;

  factory TransformJWTParamsES256.fromParams(TransformJWTParams params) => TransformJWTParamsES256(
        expiresInSeconds: params.expiresInSeconds,
        issuer: params.issuer,
        privateKey: params.privateKey,
        publicKey: params.publicKey,
      );

  factory TransformJWTParamsES256.fromEnvironment() => TransformJWTParamsES256(
        expiresInSeconds: const int.fromEnvironment('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: const String.fromEnvironment('JWT_ISSUER', defaultValue: ''),
        privateKey: const String.fromEnvironment('JWT_PRIVATE_KEY', defaultValue: ''),
        publicKey: const String.fromEnvironment('JWT_PUBLIC_KEY', defaultValue: ''),
      );

  factory TransformJWTParamsES256.fromMap(Map<String, dynamic> map) => TransformJWTParamsES256(
        expiresInSeconds: map.valueIntNotNull('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: map.valueStringNotNull('JWT_ISSUER'),
        privateKey: map.valueStringNotNull('JWT_PRIVATE_KEY'),
        publicKey: map.valueStringNotNull('JWT_PUBLIC_KEY'),
      );

  factory TransformJWTParamsES256.fromFiles() {
    var yaml = loadYaml(File('jwt/jwt.yaml').readAsStringSync()) as Map;
    final int expiresInSeconds = yaml['expiresInSeconds'] as int;
    final String issuer = yaml['issuer'] as String;
    final privateKey = File('jwt/es256/private_key.pem').readAsStringSync();
    final publicKey = File('jwt/es256/public_key.pem').readAsStringSync();
    return TransformJWTParamsES256(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
  }
}

// RSACert

class TransformJWTParamsBuilderRSACert {
  TransformJWTParamsRSACert fromMap(Map<String, dynamic> map) => TransformJWTParamsRSACert.fromMap(map);

  TransformJWTParamsRSACert fromEnvironment() => TransformJWTParamsRSACert.fromEnvironment();

  TransformJWTParamsRSACert fromFiles() => TransformJWTParamsRSACert.fromFiles();

  TransformJWTParamsRSACert fromValues({required int expiresInSeconds, required String issuer, required String privateKey, required String publicKey}) => TransformJWTParamsRSACert(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
}

class TransformJWTParamsRSACert extends TransformJWTParams {
  TransformJWTParamsRSACert({required super.expiresInSeconds, required super.issuer, required super.privateKey, required super.publicKey});

  @override
  TransformJWTType get type => TransformJWTType.rsaCert;

  factory TransformJWTParamsRSACert.fromParams(TransformJWTParams params) => TransformJWTParamsRSACert(
        expiresInSeconds: params.expiresInSeconds,
        issuer: params.issuer,
        privateKey: params.privateKey,
        publicKey: params.publicKey,
      );

  factory TransformJWTParamsRSACert.fromEnvironment() => TransformJWTParamsRSACert(
        expiresInSeconds: const int.fromEnvironment('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: const String.fromEnvironment('JWT_ISSUER', defaultValue: ''),
        privateKey: const String.fromEnvironment('JWT_PRIVATE_KEY', defaultValue: ''),
        publicKey: const String.fromEnvironment('JWT_PUBLIC_KEY', defaultValue: ''),
      );

  factory TransformJWTParamsRSACert.fromMap(Map<String, dynamic> map) => TransformJWTParamsRSACert(
        expiresInSeconds: map.valueIntNotNull('JWT_EXPIRES_IN_SECONDS', defaultValue: 3600),
        issuer: map.valueStringNotNull('JWT_ISSUER'),
        privateKey: map.valueStringNotNull('JWT_PRIVATE_KEY'),
        publicKey: map.valueStringNotNull('JWT_PUBLIC_KEY'),
      );

  factory TransformJWTParamsRSACert.fromFiles() {
    var yaml = loadYaml(File('jwt/jwt.yaml').readAsStringSync()) as Map;
    final int expiresInSeconds = yaml['expiresInSeconds'] as int;
    final String issuer = yaml['issuer'] as String;
    final privateKey = File('jwt/rsa/private_key.pem').readAsStringSync();
    final publicKey = File('jwt/rsa/certificate.pem').readAsStringSync();
    return TransformJWTParamsRSACert(expiresInSeconds: expiresInSeconds, issuer: issuer, privateKey: privateKey, publicKey: publicKey);
  }
}
