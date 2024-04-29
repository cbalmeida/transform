import 'package:testeexemplo/src/params/server_params.dart';
import 'package:testeexemplo/src/usecases/usecases.dart';
import 'package:testeexemplo/src/webserver/webserver.dart';
import 'package:transform/transform.dart';

import '../generated/generated.dart';

class Transform {
  Transform._();

  static Future<void> start() async {
    try {
      TransformInjector injector = TransformInjector();

      UseCases.register(injector);
      Objects.register(injector);

      TransformDatabase database = TransformDatabase.fromParams(await ServerParams.databaseParams);
      injector.addInstance<TransformDatabase>(database);
      for (TransformObject object in Objects.objects) {
        database.registerTable(object.model.databaseTable);
      }

      TransformWebServer webServer = WebServer(apis: Apis(injector).all, params: await ServerParams.webServerParams);
      injector.addInstance<TransformWebServer>(webServer);

      TransformJWT jwt = TransformJWT.fromParams(await ServerParams.jwtParams);
      injector.addInstance<TransformJWT>(jwt);

      injector.commit();

      Util.log("============ Database ============");
      TransformEither<Exception, bool> databaseStartResult = await database.start();
      if (databaseStartResult.isLeft) throw databaseStartResult.left;

      Util.log("============ Webserver ============");
      TransformEither<Exception, bool> webServerStartResult = await webServer.start();
      if (webServerStartResult.isLeft) throw webServerStartResult.left;

      Util.log("============ Server ============");
      Util.log("Server initialization completed!");
    } catch (e) {
      Util.logError("Error starting server:\n$e");
    }
  }
}
