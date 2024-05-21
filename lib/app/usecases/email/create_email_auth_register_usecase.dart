import 'package:transform/transform.dart';

class CreateEmailAuthRegisterUseCase extends TransformUseCase<EmailOutBox> {
  final CreateEmailOutBoxUseCase createEmailOutBoxUseCase;

  CreateEmailAuthRegisterUseCase({required this.createEmailOutBoxUseCase, required super.params});

  @override
  Future<TransformEither<Exception, EmailOutBox>> call({
    required TransformDatabaseSession session,
    required String email,
    required String verificationCode,
  }) async {
    final TransformEmailAddress sender = TransformEmailAddress(email: params.emailSenderParams?.senderEmail ?? "", name: params.emailSenderParams?.senderName ?? "");
    final TransformEmailAddress recipient = TransformEmailAddress(email: email, name: '');
    final List<TransformEmailAddress> ccRecipient = [];
    final List<TransformEmailAddress> bccRecipient = [];
    final String subject = 'Email Verification';
    final String textBody = 'Email Verification Code: $verificationCode';
    final String htmlBody = '<p>Your verification code is <strong>$verificationCode</strong></p>';
    return createEmailOutBoxUseCase(
      session: session,
      sender: sender,
      recipients: [recipient],
      ccRecipients: ccRecipient,
      bccRecipients: bccRecipient,
      subject: subject,
      textBody: textBody,
      htmlBody: htmlBody,
    );
  }
}
