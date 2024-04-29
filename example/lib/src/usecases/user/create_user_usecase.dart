import 'package:transform/transform.dart';

import '../../../generated/generated.dart';

class CreateUserUseCase extends TransformUseCase<User> {
  final UserObject userObject;

  CreateUserUseCase({required this.userObject, required super.database});

  @override
  Future<TransformEither<Exception, User>> call({required String email, required String password}) {
    return database.transaction<User>((session) async {
      TransformEither<Exception, List<User>> users = await userObject.select.where(userObject.email.equals(email)).execute(session);
      if (users.isLeft) {
        await session.rollback();
        return Left(users.left);
      }
      if (users.right.isNotEmpty) {
        await session.rollback();
        return Left(Exception("User already exists!"));
      }

      User user = User.fromEmailPassword(email, password);
      users = await userObject.insert.values([user]).execute(session);
      if (users.isLeft) {
        await session.rollback();
        return Left(users.left);
      }

      return Right(users.right.first);
    });
  }
}
