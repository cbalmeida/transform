import 'package:testeexemplo/generated/api/api.dart';
import 'package:transform/transform.dart';

class WebServer extends TransformWebServer {
  WebServer() : super(apis: Api.all);

  @override
  Future<TransformWebServerParams> get params async => TransformWebServerParams.fromMap({
        "WEBSERVER_HOST": 'localhost',
        "WEBSERVER_PORT": 8080,
      });
}
