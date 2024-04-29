import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../../transform.dart';

class TransformWebServerParams {
  final String host;
  final int port;

  TransformWebServerParams({required this.host, required this.port});

  factory TransformWebServerParams.fromEnvironment() {
    String host = const String.fromEnvironment('WEBSERVER_HOST', defaultValue: 'localhost');
    int port = const int.fromEnvironment('WEBSERVER_PORT', defaultValue: 8080);
    return TransformWebServerParams(host: host, port: port);
  }

  factory TransformWebServerParams.fromMap(Map<String, dynamic> map) {
    String host = Util.stringFromMapNotNull(map, 'WEBSERVER_HOST', 'localhost');
    int port = Util.intFromMapNotNull(map, 'WEBSERVER_PORT', 8080);
    return TransformWebServerParams(host: host, port: port);
  }

  factory TransformWebServerParams.fromValues({required String host, required int port}) {
    return TransformWebServerParams(host: host, port: port);
  }
}

abstract class TransformWebServer {
  final List<TransformApi> apis;
  final TransformWebServerParams params;

  TransformWebServer({required this.apis, required this.params});

  HttpServer? _httpServer;

  Future<TransformEither<Exception, bool>> start() async {
    try {
      final router = Router();
      for (TransformApi api in apis) {
        String apiPath = '/api/v${api.version}';
        Util.log("  Registering API version ${api.version}...");
        router.mount(apiPath, api.router.call);
        for (TransformRoute route in api.routes) {
          Util.log("    Route registered: $apiPath${route.path} [${route.method}]");
        }
      }

      TransformWebServerParams params = await this.params;
      _httpServer = await shelf_io.serve(router.call, params.host, params.port);
      Util.log("  Webserver service is listening: ${params.host}:${params.port}");

      return Right(true);
    } on Exception catch (e) {
      return Left(Exception("Error starting Webserver layer:\n$e"));
    }
  }
}
