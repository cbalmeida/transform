class TransformJWTException implements Exception {
  final String message;

  TransformJWTException(this.message);

  @override
  String toString() => 'TransformJWTException: $message';
}

class TransformJWTExceptionExpired extends TransformJWTException {
  TransformJWTExceptionExpired() : super('jwt expired');
}
