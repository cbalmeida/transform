import 'package:transform/transform.dart';

class AuthForgotPasswordUseCase extends TransformUseCase<User> {
  final UserObject userObject;
  final CreateEmailAuthForgotPasswordUseCase createEmailAuthForgotPasswordUseCase;

  AuthForgotPasswordUseCase({
    required this.userObject,
    required this.createEmailAuthForgotPasswordUseCase,
    required super.params,
  });

  Future<TransformEither<AuthForgotPasswordUseCaseException, AuthForgotPasswordUseCaseResponse>> call({required String email}) {
    return database.transaction<AuthForgotPasswordUseCaseException, AuthForgotPasswordUseCaseResponse>((session) async {
      TransformEither<Exception, List<User>> selectResponse = await userObject.databaseTable.select.where(userObject.email.equals(email)).execute(session);

      if (selectResponse.isLeft) {
        await session.rollback();
        return Left(AuthForgotPasswordUseCaseExceptionInternalServerError(selectResponse.left));
      }

      List<User> users = selectResponse.right;
      if (users.isEmpty) {
        await session.rollback();
        return Left(AuthForgotPasswordUseCaseExceptionUserNotFound(email));
      }

      User user = users.first;
      user = user.setVerificationCode(Util.generateVerificationCode());
      user = user.resetVerificationAttempts();
      TransformEither<Exception, List<User>> insertResponse = await userObject.databaseTable.update.setValue(user).execute(session);
      if (insertResponse.isLeft) {
        await session.rollback();
        return Left(AuthForgotPasswordUseCaseExceptionInternalServerError(insertResponse.left));
      }

      TransformEither<Exception, EmailOutBox> createEmailResponse = await createEmailAuthForgotPasswordUseCase(session: session, email: email, verificationCode: user.verificationCode);
      if (createEmailResponse.isLeft) {
        await session.rollback();
        return Left(AuthForgotPasswordUseCaseExceptionInternalServerError(createEmailResponse.left));
      }

      return Right(AuthForgotPasswordUseCaseResponse(email: email));
    });
  }
}

class AuthForgotPasswordUseCaseResponse {
  final String email;

  AuthForgotPasswordUseCaseResponse({required this.email});
}

enum AuthForgotPasswordUseCaseExceptionType {
  internalServerError,
  userNotFound,
}

abstract class AuthForgotPasswordUseCaseException implements Exception {
  AuthForgotPasswordUseCaseExceptionType get type;
}

class AuthForgotPasswordUseCaseExceptionInternalServerError extends AuthForgotPasswordUseCaseException {
  final Exception exception;
  AuthForgotPasswordUseCaseExceptionInternalServerError(this.exception);

  @override
  AuthForgotPasswordUseCaseExceptionType get type => AuthForgotPasswordUseCaseExceptionType.internalServerError;
}

class AuthForgotPasswordUseCaseExceptionUserNotFound extends AuthForgotPasswordUseCaseException {
  final String email;
  AuthForgotPasswordUseCaseExceptionUserNotFound(this.email);

  @override
  AuthForgotPasswordUseCaseExceptionType get type => AuthForgotPasswordUseCaseExceptionType.userNotFound;
}
