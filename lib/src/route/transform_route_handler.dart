part of 'transform_route.dart';

abstract class TransformRouteHandler<I extends TransformRouteInput, O extends TransformRouteOutput> {
  final TransformJWT jwt;
  const TransformRouteHandler({required this.jwt});

  Future<TransformRouteResponse<O>> handler(TransformRouteHandlerInputs<I> input);

  I inputFromParams(Map<String, dynamic> params);

  TransformEither<Exception, TransformJWTPayload> decodeToken(String token) => jwt.decodeToken(token);

  bool get checkToken => true;
}

class TransformRouteHandlerInputs<I> {
  final I params;
  final TransformJWTPayload tokenPayload;

  TransformRouteHandlerInputs({required this.params, required this.tokenPayload});
}
