import 'package:transform/transform.dart';

enum EmailOutBoxStatus {
  pending(0),
  sent(1),
  failed(-1);

  final int status;

  const EmailOutBoxStatus(this.status);

  factory EmailOutBoxStatus.fromValue(int value) {
    switch (value) {
      case 0:
        return EmailOutBoxStatus.pending;
      case 1:
        return EmailOutBoxStatus.sent;
      case -1:
        return EmailOutBoxStatus.failed;
      default:
        throw ArgumentError('Invalid EmailOutBoxStatus value: $value');
    }
  }
}

class EmailOutBox extends TransformMapped {
  final String? id;
  final EmailOutBoxStatus status;
  final TransformEmailAddress sender;
  final List<TransformEmailAddress> recipients;
  final List<TransformEmailAddress> ccRecipients;
  final List<TransformEmailAddress> bccRecipients;
  final String subject;
  final String textBody;
  final String htmlBody;
  final DateTime createdAt;
  final DateTime? sentAt;

  @override
  List<String> get primaryKeyColumns => ['id'];

  EmailOutBox setSent() => copyWith(status: EmailOutBoxStatus.sent, sentAt: DateTime.now());

  EmailOutBox({
    required this.id,
    required this.status,
    required this.sender,
    required this.recipients,
    required this.ccRecipients,
    required this.bccRecipients,
    required this.subject,
    required this.textBody,
    required this.htmlBody,
    required this.createdAt,
    required this.sentAt,
  });

  factory EmailOutBox.fromMap(Map<String, dynamic> map) {
    return EmailOutBox(
      id: map.valueString('id'),
      status: EmailOutBoxStatus.fromValue(map.valueIntNotNull('status')),
      sender: TransformEmailAddress.fromMap(map.valueMapNotNull('sender')),
      recipients: TransformEmailAddress.fromJsonList(map.valueStringNotNull('recipients', defaultValue: '[]')),
      ccRecipients: TransformEmailAddress.fromJsonList(map.valueStringNotNull('cc_recipients', defaultValue: '[]')),
      bccRecipients: TransformEmailAddress.fromJsonList(map.valueStringNotNull('bcc_recipients', defaultValue: '[]')),
      subject: map.valueStringNotNull('subject'),
      textBody: map.valueStringNotNull('text_body'),
      htmlBody: map.valueStringNotNull('html_body'),
      createdAt: map.valueDateTimeNotNull('created_at'),
      sentAt: map.valueDateTime('sent_at'),
    );
  }

  factory EmailOutBox.newMessage({
    required TransformEmailAddress sender,
    required List<TransformEmailAddress> recipients,
    required List<TransformEmailAddress> ccRecipients,
    required List<TransformEmailAddress> bccRecipients,
    required String subject,
    required String textBody,
    required String htmlBody,
  }) =>
      EmailOutBox(
        id: null,
        status: EmailOutBoxStatus.pending,
        sender: sender,
        recipients: recipients,
        ccRecipients: ccRecipients,
        bccRecipients: bccRecipients,
        subject: subject,
        textBody: textBody,
        htmlBody: htmlBody,
        createdAt: DateTime.now(),
        sentAt: null,
      );

  EmailOutBox copyWith({
    String? id,
    EmailOutBoxStatus? status,
    TransformEmailAddress? sender,
    List<TransformEmailAddress>? recipients,
    List<TransformEmailAddress>? ccRecipients,
    List<TransformEmailAddress>? bccRecipients,
    String? subject,
    String? textBody,
    String? htmlBody,
    DateTime? createdAt,
    DateTime? sentAt,
  }) {
    return EmailOutBox(
      id: id ?? this.id,
      status: status ?? this.status,
      sender: sender ?? this.sender,
      recipients: recipients ?? this.recipients,
      ccRecipients: ccRecipients ?? this.ccRecipients,
      bccRecipients: bccRecipients ?? this.bccRecipients,
      subject: subject ?? this.subject,
      textBody: textBody ?? this.textBody,
      htmlBody: htmlBody ?? this.htmlBody,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.status,
      'sender': sender,
      'recipients': recipients,
      'cc_recipients': ccRecipients,
      'bcc_recipients': bccRecipients,
      'subject': subject,
      'text_body': textBody,
      'html_body': htmlBody,
      'created_at': createdAt,
      'sent_at': sentAt,
    };
  }
}

class EmailOutBoxAdapter extends TransformModelAdapter<EmailOutBox> {
  @override
  EmailOutBox fromMap(Map<String, dynamic> map) => EmailOutBox.fromMap(map);

  @override
  Map<String, dynamic> toMap(EmailOutBox model) => model.toMap();
}

class EmailOutBoxObject extends TransformObject<EmailOutBox> {
  EmailOutBoxObject() : super(model: EmailOutboxModel(), adapter: EmailOutBoxAdapter());

  TransformDatabaseQueryBuilderCondition get isPending => model.columnByName('status').equals(0);

  List<TransformDatabaseQueryBuilderOrderBy> get orderById => [TransformDatabaseQueryBuilderOrderBy.asc('id')];
}
