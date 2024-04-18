part of 'transform_route.dart';

abstract class TransformRouteHandler<I extends TransformRouteInput, O extends TransformRouteOutput> {
  const TransformRouteHandler();

  Future<TransformRouteResponse<O>> handler(I input);

  I inputFromParams(Map<String, dynamic> params);
}
