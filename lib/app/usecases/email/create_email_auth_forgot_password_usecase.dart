import 'package:transform/transform.dart';

class CreateEmailAuthForgotPasswordUseCase extends TransformUseCase<EmailOutBox> {
  final CreateEmailOutBoxUseCase createEmailOutBoxUseCase;

  CreateEmailAuthForgotPasswordUseCase({required this.createEmailOutBoxUseCase, required super.params});

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
    final String subject = 'Forgot Password';
    final String textBody = 'Your Forgot Password Code is $verificationCode';
    final String htmlBody = '<p>Your Forgot Password Code is <strong>$verificationCode</strong></p>';
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
