part of '../transform_email_sender.dart';

class TransformEmailSenderGmail extends TransformEmailSender {
  final TransformEmailSenderParamsGmail params;

  TransformEmailSenderGmail(this.params);

  @override
  TransformEmailSenderType get type => TransformEmailSenderType.gmail;

  @override
  smtp.SmtpServer get smtpServer => smtp.gmail(params.user, params.password);

  @override
  String serviceDescription() {
    return "Gmail (user: ${params.user}, sender: ${params.senderEmail})";
  }
}

class TransformEmailSenderParamsGmail extends TransformEmailSenderParams {
  final String user;
  final String password;

  TransformEmailSenderParamsGmail({required this.user, required this.password, required super.senderEmail, required super.senderName}) : super(type: TransformEmailSenderType.gmail);
}

class TransformEmailSenderParamsBuilderGmail {
  TransformEmailSenderParamsGmail fromMap(Map<String, dynamic> map) {
    String user = map.valueStringNotNull('GMAIL_USER', defaultValue: 'user');
    String password = map.valueStringNotNull('GMAIL_PASSWORD', defaultValue: 'password');
    String senderEmail = map.valueStringNotNull('GMAIL_SENDER_EMAIL', defaultValue: 'my_email@my_domain.com');
    String senderName = map.valueStringNotNull('GMAIL_SENDER_NAME', defaultValue: 'My Name');
    return fromVales(user: user, password: password, senderEmail: senderEmail, senderName: senderName);
  }

  TransformEmailSenderParamsGmail fromEnvironment() {
    String user = const String.fromEnvironment('GMAIL_USER', defaultValue: 'user');
    String password = const String.fromEnvironment('GMAIL_PASSWORD', defaultValue: 'password');
    String senderEmail = const String.fromEnvironment('GMAIL_SENDER_EMAIL', defaultValue: 'my_email@my_domain.com');
    String senderName = const String.fromEnvironment('GMAIL_SENDER_NAME', defaultValue: 'My Name');
    return fromVales(user: user, password: password, senderEmail: senderEmail, senderName: senderName);
  }

  TransformEmailSenderParamsGmail fromVales({
    required String user,
    required String password,
    required String senderEmail,
    required String senderName,
  }) =>
      TransformEmailSenderParamsGmail(
        user: user,
        password: password,
        senderEmail: senderEmail,
        senderName: senderName,
      );
}
