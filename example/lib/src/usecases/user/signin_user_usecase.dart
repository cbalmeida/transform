import 'package:transform/transform.dart';

import '../../../generated/generated.dart';

class SigninUserUseCase extends TransformUseCase<User> {
  final UserObject userObject;
  final TransformJWT jwt;

  SigninUserUseCase({required this.userObject, required this.jwt, required super.databaseParams});

  @override
  Future<TransformEither<Exception, String>> call({required String email, required String password}) {
    return database.transaction<String>((session) async {
      TransformEither<Exception, List<User>> users = await userObject.select.where(userObject.email.equals(email)).execute(session);
      if (users.isLeft) {
        await session.rollback();
        return Left(users.left);
      }
      if (users.right.isEmpty) {
        await session.rollback();
        return Left(SigninUserUseCaseExceptionUserNotFound(email));
      }

      User user = users.right.first;
      String hashedPassword = user.hashedPassword;
      bool passwordValid = Util.checkPassword(password, hashedPassword);
      if (!passwordValid) {
        await session.rollback();
        return Left(SigninUserUseCaseExceptionInvalidPassword(email));
      }

      final tokenResponse = jwt.generateToken(email, password);
      if (tokenResponse.isLeft) {
        await session.rollback();
        return Left(tokenResponse.left);
      }

      String token = tokenResponse.right;
      return Right(token);
    });
  }
}

class SigninUserUseCaseExceptionUserNotFound implements Exception {
  final String email;
  SigninUserUseCaseExceptionUserNotFound(this.email);
}

class SigninUserUseCaseExceptionInvalidPassword implements Exception {
  final String email;
  SigninUserUseCaseExceptionInvalidPassword(this.email);
}
