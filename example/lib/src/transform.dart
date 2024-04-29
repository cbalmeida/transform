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

      TransformDatabaseParams databaseParams = await ServerParams.databaseParams;
      injector.addInstance<TransformDatabaseParams>(databaseParams);

      TransformJWT jwt = TransformJWT.fromParams(await ServerParams.jwtParams);
      injector.addInstance<TransformJWT>(jwt);

      TransformWebServerParams webServerParams = await ServerParams.webServerParams;
      injector.addInstance<TransformWebServerParams>(webServerParams);

      injector.commit();

      Util.log("============ Database ============");
      TransformDatabase database = TransformDatabase.fromParams(databaseParams);
      for (TransformObject object in Objects.objects) {
        database.registerTable(object.model.databaseTable);
      }
      TransformEither<Exception, bool> databaseStartResult = await database.start();
      if (databaseStartResult.isLeft) throw databaseStartResult.left;

      Util.log("============ Webserver ============");
      TransformWebServer webServer = WebServer(apis: Apis(injector).all, params: webServerParams);
      TransformEither<Exception, bool> webServerStartResult = await webServer.start();
      if (webServerStartResult.isLeft) throw webServerStartResult.left;

      Util.log("============ Server ============");
      Util.log("Server initialization completed!");
    } catch (e) {
      Util.logError("Error starting server:\n$e");
    }
  }
}
