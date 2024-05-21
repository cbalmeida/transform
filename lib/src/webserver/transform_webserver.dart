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
    String url = const String.fromEnvironment('WEBSERVER_URL', defaultValue: 'localhost');
    return TransformWebServerParams(host: host, port: port);
  }

  factory TransformWebServerParams.fromMap(Map<String, dynamic> map) {
    String host = map.valueStringNotNull('WEBSERVER_HOST', defaultValue: 'localhost');
    int port = map.valueIntNotNull('WEBSERVER_PORT', defaultValue: 8080);
    String url = map.valueStringNotNull('WEBSERVER_URL', defaultValue: 'localhost');
    return TransformWebServerParams(host: host, port: port);
  }

  factory TransformWebServerParams.fromValues({required String host, required int port}) {
    return TransformWebServerParams(host: host, port: port);
  }
}

class TransformWebServer {
  // final List<TransformRoute> auth;
  final TransformWebServerParams params;
  final List<TransformRoutes> apis;

  TransformWebServer({required this.params, required this.apis});

  Future<TransformEither<Exception, bool>> start(TransformInjector injector) async {
    try {
      final router = Router();

      for (TransformRoutes api in apis) {
        String apiPath = api.path; // '/api/v${api.version}';
        Util.log("  Registering routes at: $apiPath");
        router.mount(apiPath, api.router(injector).call);
        for (TransformRoute route in api.routes) {
          Util.log("    $apiPath${route.path} [${route.method}]");
        }
      }

      // Bind with a secure HTTPS connection
      SecurityContext getSecurityContext() {
        final chain = Platform.script.resolve('certificates/server_chain.pem').toFilePath();
        final key = Platform.script.resolve('certificates/server_key.pem').toFilePath();

        return SecurityContext()
          ..useCertificateChain(chain)
          ..usePrivateKey(key, password: 'dartdart');
      }

      TransformWebServerParams params = this.params;
      await shelf_io.serve(router.call, params.host, params.port, securityContext: _securityContext);
      Util.log("  Webserver service is listening: ${params.host}:${params.port}");

      return Right(true);
    } on Exception catch (e) {
      return Left(Exception("Error starting Webserver layer:\n$e"));
    }
  }

  SecurityContext? get _securityContext {
    /*
    final chain = Platform.script.resolve('certificates/server_chain.pem').toFilePath();
    final key = Platform.script.resolve('certificates/server_key.pem').toFilePath();

    return SecurityContext()
      ..useCertificateChain(chain)
      ..usePrivateKey(key, password: 'dartdart');
     */
    return null;
  }
}
