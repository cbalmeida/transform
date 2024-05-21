import 'package:transform/transform.dart';

class GetPendingEmailsOutBoxUseCase extends TransformUseCase<EmailOutBox> {
  final EmailOutBoxObject emailOutBoxObject;

  GetPendingEmailsOutBoxUseCase({required this.emailOutBoxObject, required super.params});

  @override
  Future<TransformEither<Exception, List<EmailOutBox>>> call({int limitTo = 10}) async {
    return database.transaction<Exception, List<EmailOutBox>>((session) async {
      TransformEither<Exception, List<EmailOutBox>> selectResult = await emailOutBoxObject.databaseTable.select.where(emailOutBoxObject.isPending).orderBy(emailOutBoxObject.orderById).limit(limitTo).execute(session);
      return selectResult;
    });
  }
}
