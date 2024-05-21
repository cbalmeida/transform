import 'package:testeexemplo/src/providers/providers.dart';
import 'package:testeexemplo/src/routes/v1/api_v1.dart';
import 'package:testeexemplo/src/usecases/usecases.dart';
import 'package:transform/transform.dart';

import 'generated/objects/objects.dart';
import 'src/params/server_params.dart';

void main() async {
  TransformDatabaseParams databaseParams = await ServerParams.databaseParams;
  TransformJWTParams jwtParams = await ServerParams.jwtParams;
  TransformWebServerParams webServerParams = await ServerParams.webServerParams;
  TransformEmailSenderParams emailSenderParams = await ServerParams.emailSenderParams;
  TransformRouteLimiterParams routeLimiterParams = await ServerParams.routeLimiterParams;
  List<TransformRoutes> routes = [ApiV1()];
  TransformUseCases useCases = UseCases();
  TransformObjects objects = Objects();
  TransformProviders providers = Providers();

  Transform.start(
    databaseParams: databaseParams,
    jwtParams: jwtParams,
    webServerParams: webServerParams,
    emailSenderParams: emailSenderParams,
    routeLimiterParams: routeLimiterParams,
    routes: routes,
    useCases: useCases,
    objects: objects,
    providers: providers,
  );
}
