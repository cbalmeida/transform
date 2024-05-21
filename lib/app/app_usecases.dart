import '../transform.dart';

class AppUseCases extends TransformUseCases {
  @override
  void registerUseCases(TransformInjector injector) {
    // auth
    injector.add<AuthLoginUseCase>(AuthLoginUseCase.new);
    injector.add<AuthRegisterUseCase>(AuthRegisterUseCase.new);
    injector.add<AuthActivateUseCase>(AuthActivateUseCase.new);
    injector.add<AuthForgotPasswordUseCase>(AuthForgotPasswordUseCase.new);

    // email
    injector.add<CreateEmailOutBoxUseCase>(CreateEmailOutBoxUseCase.new);
    injector.add<CreateEmailAuthRegisterUseCase>(CreateEmailAuthRegisterUseCase.new);
    injector.add<CreateEmailAuthForgotPasswordUseCase>(CreateEmailAuthForgotPasswordUseCase.new);
    injector.add<GetPendingEmailsOutBoxUseCase>(GetPendingEmailsOutBoxUseCase.new);
    injector.add<SetSentEmailOutBoxUseCase>(SetSentEmailOutBoxUseCase.new);
  }
}
