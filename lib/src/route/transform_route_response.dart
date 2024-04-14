part of 'transform_route.dart';

abstract class TransformRouteResponse<O extends TransformRouteOutput> {
  const TransformRouteResponse();

  Response toResponse();

  static TransformRouteResponse<O> ok<O extends TransformRouteOutput>(O output) => TransformRouteResponseOK(output: output);

  static TransformRouteResponse<O> notFound<O extends TransformRouteOutput>(Object? object) => TransformRouteResponseNotFound(object: object);

  static TransformRouteResponse<O> badRequest<O extends TransformRouteOutput>() => TransformRouteResponseBadRequest();
}

class TransformRouteResponseOK<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseOK({required this.output});

  @override
  Response toResponse() => Response.ok(output.toJson());
}

class TransformRouteResponseNotFound<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final Object? object;
  const TransformRouteResponseNotFound({required this.object});

  @override
  Response toResponse() => Response.notFound(object);
}

class TransformRouteResponseBadRequest<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  const TransformRouteResponseBadRequest();

  @override
  Response toResponse() => Response.badRequest();
}
