import 'dart:async';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart' as smtp;

import '../../../transform.dart';

part 'types/transform_email_sender_gmail.dart';

enum TransformEmailSenderType { gmail }

abstract class TransformEmailSender {
  TransformEmailSenderType get type;

  smtp.SmtpServer get smtpServer;

  String serviceDescription();

  static TransformEmailSender gmail(TransformEmailSenderParamsGmail params) => TransformEmailSenderGmail(params);

  static TransformEmailSender fromParams(TransformEmailSenderParams params) {
    switch (params.type) {
      case TransformEmailSenderType.gmail:
        return gmail(params as TransformEmailSenderParamsGmail);
      default:
        throw Exception("Email Sender type not implemented: ${params.type}");
    }
  }

  Timer? _timer;
  GetPendingEmailsOutBoxUseCase? _getPendingEmailsOutBoxUseCase;
  SetSentEmailOutBoxUseCase? _setSentEmailOutBoxUseCase;
  bool _busy = false;

  Future<TransformEither<Exception, bool>> start(TransformInjector injector) async {
    _getPendingEmailsOutBoxUseCase = injector.get<GetPendingEmailsOutBoxUseCase>();
    _setSentEmailOutBoxUseCase = injector.get<SetSentEmailOutBoxUseCase>();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => _onTimer());

    Util.log("  Email Sender service is running:");
    Util.log("  ${serviceDescription()}");

    return Right(true);
  }

  _onTimer() async {
    if (_busy) return;
    _busy = true;
    try {
      await _sendEmails();
    } catch (e) {
      print("Email Sender error: $e");
    }
    _busy = false;
  }

  Future<bool> _sendEmails() async {
    TransformEither<Exception, List<EmailOutBox>> resultPendingEmails = await _getPendingEmailsOutBoxUseCase!();
    if (resultPendingEmails.isLeft) {
      print("Email Sender error: ${resultPendingEmails.left}");
      return false;
    }

    List<EmailOutBox> emails = resultPendingEmails.right;
    if (emails.isEmpty) {
      return true;
    }

    print("Email Sender sending ${emails.length} emails");
    for (EmailOutBox email in emails) {
      TransformEither<Exception, mailer.SendReport> sent = await _sendEmail(email);
      if (sent.isLeft) {
        print("Email Sender error: failed to send email ${sent.left}");
        return false;
      }

      TransformEither<Exception, EmailOutBox> resultSetEmailSent = await _setSentEmailOutBoxUseCase!(email);
      if (resultSetEmailSent.isLeft) {
        print("Email Sender error: ${resultSetEmailSent.left}");
        return false;
      }
    }

    return true;
  }

  Future<TransformEither<Exception, mailer.SendReport>> _sendEmail(EmailOutBox emailOutBox) async {
    try {
      final message = mailer.Message();

      TransformEmailAddress sender = emailOutBox.sender;
      message.from = mailer.Address(sender.email, sender.name);

      message.recipients.addAll(emailOutBox.recipients.map((e) => mailer.Address(e.email, e.name)));
      message.ccRecipients.addAll(emailOutBox.ccRecipients.map((e) => mailer.Address(e.email, e.name)));
      message.bccRecipients.addAll(emailOutBox.bccRecipients.map((e) => mailer.Address(e.email, e.name)));
      message.subject = emailOutBox.subject;
      message.text = emailOutBox.textBody;
      message.html = emailOutBox.htmlBody;

      final sendReport = await mailer.send(message, smtpServer);
      return Right(sendReport);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
