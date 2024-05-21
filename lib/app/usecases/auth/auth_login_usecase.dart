import 'package:transform/transform.dart';

class AuthLoginUseCase extends TransformUseCase<User> {
  final UserObject userObject;

  AuthLoginUseCase({required this.userObject, required super.params});

  @override
  Future<TransformEither<AuthLoginUseCaseException, AuthLoginUseCaseResponse>> call({required String email, required String password}) {
    return database.transaction<AuthLoginUseCaseException, AuthLoginUseCaseResponse>((session) async {
      TransformEither<Exception, List<User>> selectResponse = await userObject.databaseTable.select.where(userObject.email.equals(email)).execute(session);

      if (selectResponse.isLeft) {
        await session.rollback();
        return Left(AuthLoginUseCaseExceptionInternalServerError(selectResponse.left));
      }

      List<User> users = selectResponse.right;
      if (users.isEmpty) {
        await session.rollback();
        return Left(AuthLoginUseCaseExceptionUserNotFound(email));
      }

      User user = users.first;
      if (!user.verified) {
        await session.rollback();
        return Left(AuthLoginUseCaseExceptionUserNotVerified(email));
      }

      String hashedPassword = user.hashedPassword;
      bool passwordValid = Util.checkPassword(password, hashedPassword);
      if (!passwordValid) {
        await session.rollback();
        return Left(AuthLoginUseCaseExceptionInvalidPassword(email));
      }

      final tokenResponse = params.jwt.generateToken(email);
      if (tokenResponse.isLeft) {
        await session.rollback();
        return Left(AuthLoginUseCaseExceptionInternalServerError(tokenResponse.left));
      }

      return Right(AuthLoginUseCaseResponse(token: tokenResponse.right));
    });
  }
}

class AuthLoginUseCaseResponse {
  final String token;

  AuthLoginUseCaseResponse({required this.token});
}

enum AuthLoginUseCaseExceptionType {
  internalServerError,
  userNotFound,
  invalidPassword,
  userNotVerified,
}

abstract class AuthLoginUseCaseException implements Exception {
  AuthLoginUseCaseExceptionType get type;
}

class AuthLoginUseCaseExceptionInternalServerError extends AuthLoginUseCaseException {
  final Exception exception;
  AuthLoginUseCaseExceptionInternalServerError(this.exception);

  @override
  AuthLoginUseCaseExceptionType get type => AuthLoginUseCaseExceptionType.internalServerError;
}

class AuthLoginUseCaseExceptionUserNotFound extends AuthLoginUseCaseException {
  final String email;
  AuthLoginUseCaseExceptionUserNotFound(this.email);

  @override
  AuthLoginUseCaseExceptionType get type => AuthLoginUseCaseExceptionType.userNotFound;
}

class AuthLoginUseCaseExceptionInvalidPassword implements AuthLoginUseCaseException {
  final String email;
  AuthLoginUseCaseExceptionInvalidPassword(this.email);

  @override
  AuthLoginUseCaseExceptionType get type => AuthLoginUseCaseExceptionType.invalidPassword;
}

class AuthLoginUseCaseExceptionUserNotVerified extends AuthLoginUseCaseException {
  final String email;
  AuthLoginUseCaseExceptionUserNotVerified(this.email);

  @override
  AuthLoginUseCaseExceptionType get type => AuthLoginUseCaseExceptionType.userNotVerified;
}
