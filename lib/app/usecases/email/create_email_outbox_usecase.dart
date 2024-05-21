import 'package:transform/transform.dart';

class CreateEmailOutBoxUseCase extends TransformUseCase<EmailOutBox> {
  final EmailOutBoxObject emailOutBoxObject;

  CreateEmailOutBoxUseCase({
    required this.emailOutBoxObject,
    required super.params,
  });

  @override
  Future<TransformEither<Exception, EmailOutBox>> call({
    required TransformDatabaseSession session,
    required TransformEmailAddress sender,
    required List<TransformEmailAddress> recipients,
    required List<TransformEmailAddress> ccRecipients,
    required List<TransformEmailAddress> bccRecipients,
    required String subject,
    required String textBody,
    required String htmlBody,
  }) async {
    EmailOutBox newMessage = EmailOutBox.newMessage(
      sender: sender,
      recipients: recipients,
      ccRecipients: ccRecipients,
      bccRecipients: bccRecipients,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
    );

    TransformEither<Exception, List<EmailOutBox>> insertResult = await emailOutBoxObject.databaseTable.insert.values(newMessage).execute(session);
    if (insertResult.isLeft) return Left(insertResult.left);

    EmailOutBox emailOutBox = insertResult.right.first;

    return Right(emailOutBox);
  }
}
