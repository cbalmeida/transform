import 'package:transform/transform.dart';

class SetSentEmailOutBoxUseCase extends TransformUseCase<EmailOutBox> {
  final EmailOutBoxObject emailOutBoxObject;

  SetSentEmailOutBoxUseCase({required this.emailOutBoxObject, required super.params});

  @override
  Future<TransformEither<Exception, EmailOutBox>> call(EmailOutBox email) async {
    return database.transaction<Exception, EmailOutBox>((session) async {
      email = email.setSent();
      TransformEither<Exception, List<EmailOutBox>> updateResult = await emailOutBoxObject.databaseTable.update.setValue(email).execute(session);
      if (updateResult.isLeft) {
        await session.rollback();
        return Left(updateResult.left);
      }
      return Right(updateResult.right.first);
    });
  }
}
