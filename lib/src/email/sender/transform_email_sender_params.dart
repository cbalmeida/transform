import 'package:transform/src/email/sender/transform_email_sender.dart';

abstract class TransformEmailSenderParams {
  final TransformEmailSenderType type;
  final String senderEmail;
  final String senderName;

  const TransformEmailSenderParams({
    required this.type,
    required this.senderEmail,
    required this.senderName,
  });

  /// Note that using a username and password for gmail only works if
  /// you have two-factor authentication enabled and created an App password.
  /// Setup a app password for the email account at: https://myaccount.google.com/apppasswords
  static TransformEmailSenderParamsBuilderGmail gmail = TransformEmailSenderParamsBuilderGmail();
}
