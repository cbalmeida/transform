import 'package:transform/transform.dart';

class AuthRegisterUseCase extends TransformUseCase<User> {
  final UserObject userObject;
  final CreateEmailAuthRegisterUseCase createEmailAuthRegisterUseCase;

  AuthRegisterUseCase({
    required this.userObject,
    required this.createEmailAuthRegisterUseCase,
    required super.params,
  });

  Future<TransformEither<AuthRegisterUseCaseException, AuthRegisterUseCaseResponse>> call({required String email, required String password}) {
    return database.transaction<AuthRegisterUseCaseException, AuthRegisterUseCaseResponse>((session) async {
      if (password.length < 4) {
        await session.rollback();
        return Left(AuthRegisterUseCaseExceptionPasswordTooShort(email));
      }

      TransformEither<Exception, List<User>> selectResponse = await userObject.databaseTable.select.where(userObject.email.equals(email)).execute(session);

      if (selectResponse.isLeft) {
        await session.rollback();
        return Left(AuthRegisterUseCaseExceptionInternalServerError(selectResponse.left));
      }

      List<User> users = selectResponse.right;
      if (users.isNotEmpty) {
        await session.rollback();
        return Left(AuthRegisterUseCaseExceptionUserAlreadyExists(email));
      }

      User user = User.fromEmailPassword(email, password, verified: false, verificationToken: Util.generateVerificationToken(), verificationCode: Util.generateVerificationCode());
      TransformEither<Exception, List<User>> insertResponse = await userObject.databaseTable.insert.values(user).execute(session);

      if (insertResponse.isLeft) {
        await session.rollback();
        return Left(AuthRegisterUseCaseExceptionInternalServerError(insertResponse.left));
      }

      TransformEither<Exception, EmailOutBox> createEmailResponse = await createEmailAuthRegisterUseCase(session: session, email: email, verificationCode: user.verificationCode);
      if (createEmailResponse.isLeft) {
        await session.rollback();
        return Left(AuthRegisterUseCaseExceptionInternalServerError(createEmailResponse.left));
      }

      return Right(AuthRegisterUseCaseResponse(email: email));
    });
  }
}

class AuthRegisterUseCaseResponse {
  final String email;

  AuthRegisterUseCaseResponse({required this.email});
}

enum AuthRegisterUseCaseExceptionType {
  internalServerError,
  passwordTooShort,
  userAlreadyExists,
}

abstract class AuthRegisterUseCaseException implements Exception {
  AuthRegisterUseCaseExceptionType get type;
}

class AuthRegisterUseCaseExceptionInternalServerError extends AuthRegisterUseCaseException {
  final Exception exception;
  AuthRegisterUseCaseExceptionInternalServerError(this.exception);

  @override
  AuthRegisterUseCaseExceptionType get type => AuthRegisterUseCaseExceptionType.internalServerError;
}

class AuthRegisterUseCaseExceptionUserAlreadyExists extends AuthRegisterUseCaseException {
  final String email;
  AuthRegisterUseCaseExceptionUserAlreadyExists(this.email);

  @override
  AuthRegisterUseCaseExceptionType get type => AuthRegisterUseCaseExceptionType.userAlreadyExists;
}

class AuthRegisterUseCaseExceptionPasswordTooShort extends AuthRegisterUseCaseException {
  final String email;
  AuthRegisterUseCaseExceptionPasswordTooShort(this.email);

  @override
  AuthRegisterUseCaseExceptionType get type => AuthRegisterUseCaseExceptionType.passwordTooShort;
}
