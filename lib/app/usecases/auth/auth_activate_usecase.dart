import 'package:transform/transform.dart';

class AuthActivateUseCase extends TransformUseCase<User> {
  final UserObject userObject;

  AuthActivateUseCase({
    required this.userObject,
    required super.params,
  });

  Future<TransformEither<AuthActivateUseCaseException, AuthActivateUseCaseResponse>> call({required String email, required String verificationCode}) {
    return database.transaction<AuthActivateUseCaseException, AuthActivateUseCaseResponse>((session) async {
      TransformEither<Exception, List<User>> selectResponse = await userObject.databaseTable.select.where(userObject.email.equals(email)).execute(session);

      if (selectResponse.isLeft) {
        await session.rollback();
        return Left(AuthActivateUseCaseExceptionInternalServerError(selectResponse.left));
      }

      List<User> users = selectResponse.right;
      if (users.isEmpty) {
        await session.rollback();
        return Left(AuthActivateUseCaseExceptionUserNotFound(email));
      }

      User user = users.first;
      if (user.verified) {
        await session.rollback();
        return Left(AuthActivateUseCaseExceptionUserAlreadyVerified(email));
      }

      if (user.verificationAttempts >= 3) {
        await session.rollback();
        return Left(AuthActivateUseCaseExceptionTooManyRequests(email));
      }

      if (user.verificationCode != verificationCode) {
        user = user.increaseVerificationAttempts();
        TransformEither<Exception, List<User>> updateResult = await userObject.databaseTable.update.setValue(user).execute(session);
        if (updateResult.isLeft) {
          await session.rollback();
          return Left(AuthActivateUseCaseExceptionInternalServerError(updateResult.left));
        }
        return Left(AuthActivateUseCaseExceptionVerificationCodeInvalid(email, verificationCode));
      }

      user = user.setVerified(true);
      TransformEither<Exception, List<User>> updateResult = await userObject.databaseTable.update.setValue(user).execute(session);
      if (updateResult.isLeft) {
        await session.rollback();
        return Left(AuthActivateUseCaseExceptionInternalServerError(updateResult.left));
      }

      final tokenResponse = params.jwt.generateToken(email);
      if (tokenResponse.isLeft) {
        await session.rollback();
        return Left(AuthActivateUseCaseExceptionInternalServerError(tokenResponse.left));
      }

      return Right(AuthActivateUseCaseResponse(token: tokenResponse.right));
    });
  }
}

class AuthActivateUseCaseResponse {
  final String token;

  AuthActivateUseCaseResponse({required this.token});
}

enum AuthActivateUseCaseExceptionType {
  internalServerError,
  userNotFound,
  userAlreadyVerified,
  tooManyRequests,
  verificationCodeInvalid,
}

abstract class AuthActivateUseCaseException implements Exception {
  AuthActivateUseCaseExceptionType get type;
}

class AuthActivateUseCaseExceptionInternalServerError extends AuthActivateUseCaseException {
  final Exception exception;
  AuthActivateUseCaseExceptionInternalServerError(this.exception);

  @override
  AuthActivateUseCaseExceptionType get type => AuthActivateUseCaseExceptionType.internalServerError;
}

class AuthActivateUseCaseExceptionUserNotFound extends AuthActivateUseCaseException {
  final String email;
  AuthActivateUseCaseExceptionUserNotFound(this.email);

  @override
  AuthActivateUseCaseExceptionType get type => AuthActivateUseCaseExceptionType.userNotFound;
}

class AuthActivateUseCaseExceptionTooManyRequests extends AuthActivateUseCaseException {
  final String email;
  AuthActivateUseCaseExceptionTooManyRequests(this.email);

  @override
  AuthActivateUseCaseExceptionType get type => AuthActivateUseCaseExceptionType.tooManyRequests;
}

class AuthActivateUseCaseExceptionVerificationCodeInvalid extends AuthActivateUseCaseException {
  final String email;
  final String verificationCode;
  AuthActivateUseCaseExceptionVerificationCodeInvalid(this.email, this.verificationCode);

  @override
  AuthActivateUseCaseExceptionType get type => AuthActivateUseCaseExceptionType.verificationCodeInvalid;
}

class AuthActivateUseCaseExceptionUserAlreadyVerified extends AuthActivateUseCaseException {
  final String email;
  AuthActivateUseCaseExceptionUserAlreadyVerified(this.email);

  @override
  AuthActivateUseCaseExceptionType get type => AuthActivateUseCaseExceptionType.userAlreadyVerified;
}
