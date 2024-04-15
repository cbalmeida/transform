part of 'transform_route.dart';

abstract class TransformRouteResponse<O extends TransformRouteOutput> {
  const TransformRouteResponse();

  Response toResponse();

  static TransformRouteResponse<O> ok<O extends TransformRouteOutput>(O output) => TransformRouteResponseOK(output: output);

  static TransformRouteResponse<O> notFound<O extends TransformRouteOutput>(String? message) => TransformRouteResponseNotFound(message: message);

  static TransformRouteResponse<O> badRequest<O extends TransformRouteOutput>(String? message) => TransformRouteResponseBadRequest(message: message);

  static TransformRouteResponse<O> internalServerError<O extends TransformRouteOutput>(Exception exception) => TransformRouteResponseInternalServerError(exception: exception);
}

class TransformRouteResponseOK<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseOK({required this.output});

  @override
  Response toResponse() => Response.ok(output.toJson());
}

class TransformRouteResponseNotFound<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseNotFound({required this.message});

  @override
  Response toResponse() => Response.notFound({"error": message}.toString());
}

class TransformRouteResponseBadRequest<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseBadRequest({required this.message});

  @override
  Response toResponse() => Response.badRequest(body: message);
}

class TransformRouteResponseInternalServerError<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final Exception exception;
  const TransformRouteResponseInternalServerError({required this.exception});

  @override
  Response toResponse() => Response.internalServerError(body: exception.toString());
}
