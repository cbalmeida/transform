import 'package:transform/app/app_objects.dart';
import 'package:transform/app/app_providers.dart';

import '../transform.dart';
import 'app_routes.dart';
import 'app_usecases.dart';

class Transform {
  Transform._();

  static Future<void> start({
    required TransformDatabaseParams databaseParams,
    required TransformJWTParams jwtParams,
    required TransformWebServerParams webServerParams,
    required TransformEmailSenderParams? emailSenderParams,
    required TransformRouteLimiterParams routeLimiterParams,
    required List<TransformRoutes> routes,
    required TransformUseCases useCases,
    required TransformObjects objects,
    required TransformProviders providers,
  }) async {
    try {
      TransformInjector injector = TransformInjector();

      objects.objects = [];
      objects.createObjects(injector);
      useCases.registerUseCases(injector);
      providers.registerProviders(injector);

      AppUseCases appUseCases = AppUseCases();
      appUseCases.registerUseCases(injector);

      AppObjects appObjects = AppObjects();
      appObjects.createObjects(injector);
      objects.objects.addAll(appObjects.objects);

      AppProviders appProviders = AppProviders();
      appProviders.registerProviders(injector);

      injector.addInstance<TransformRouteLimiter>(TransformRouteLimiter(routeLimiterParams));

      injector.addInstance<TransformDatabaseParams>(databaseParams);

      injector.addInstance<TransformJWTParams>(jwtParams);
      TransformJWT jwt = TransformJWT.fromParams(jwtParams);
      injector.addInstance<TransformJWT>(jwt);

      injector.addInstance<TransformWebServerParams>(webServerParams);
      if (emailSenderParams != null) {
        injector.addInstance<TransformEmailSenderParams>(emailSenderParams);
      }

      TransformUseCaseParams useCaseParams = TransformUseCaseParams(
        databaseParams: databaseParams,
        webServerParams: webServerParams,
        jwtParams: jwtParams,
        jwt: jwt,
        emailSenderParams: emailSenderParams,
      );
      injector.addInstance<TransformUseCaseParams>(useCaseParams);

      injector.commit();

      Util.log("============ Database ============");
      TransformDatabase database = TransformDatabase.fromParams(databaseParams);
      for (TransformObject object in objects.objects) {
        database.registerTable(object.databaseTable);
      }
      TransformEither<Exception, bool> databaseStartResult = await database.start();
      if (databaseStartResult.isLeft) throw databaseStartResult.left;

      Util.log("============ Webserver ============");
      routes.addAll(AppRoutes.apis);
      TransformWebServer webServer = TransformWebServer(apis: routes, params: webServerParams);
      TransformEither<Exception, bool> webServerStartResult = await webServer.start(injector);
      if (webServerStartResult.isLeft) throw webServerStartResult.left;

      Util.log("============ Email Sender ============");
      if (emailSenderParams != null) {
        TransformEmailSender emailSender = TransformEmailSender.fromParams(emailSenderParams);
        TransformEither<Exception, bool> emailSenderStartResult = await emailSender.start(injector);
        if (emailSenderStartResult.isLeft) throw emailSenderStartResult.left;
      } else {
        Util.log("Email sender disabled! (not configured)");
      }

      Util.log("============ Server ============");
      Util.log("Server initialization completed!");
    } catch (e, s) {
      Util.logError("Error starting server:\n$e");
    }
  }
}
