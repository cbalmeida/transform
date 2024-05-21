part of 'transform_route.dart';

abstract class TransformRouteHandler<I extends TransformRouteInput, O extends TransformRouteOutput> {
  final TransformJWT jwt;
  final TransformRouteLimiter limiter;
  const TransformRouteHandler({required this.jwt, required this.limiter});

  Future<TransformRouteResponse<O>> handler(TransformRouteHandlerInputs<I> input);

  I inputFromParams(Map<String, dynamic> params);

  TransformEither<Exception, TransformJWTPayload> decodeToken(String token) => jwt.decodeToken(token);

  bool get mustCheckToken => true;

  TransformEither<Exception, TransformJWTPayload> checkToken(Request request) {
    if (!mustCheckToken) return Right(TransformJWTPayload.empty());
    final String token = request.headers["Authorization"] ?? request.url.queryParameters["token"] ?? "";
    TransformEither<Exception, TransformJWTPayload> decodedToken = decodeToken(token);
    return decodedToken;
  }

  Response? checkMaxRequests(Request request) {
    final httpConnectionInfo = (request.context['shelf.io.connection_info'] as HttpConnectionInfo?);
    final String ip = httpConnectionInfo?.remoteAddress.address ?? "";
    if (limiter.isIpBlocked(ip)) {
      return Response(429, body: {"error": "Too many requests from $ip"}.toString());
    }
    return null;
  }
}

class TransformRouteHandlerInputs<I> {
  final I params;
  final TransformJWTPayload tokenPayload;

  TransformRouteHandlerInputs({required this.params, required this.tokenPayload});
}
