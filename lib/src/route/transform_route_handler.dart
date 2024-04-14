part of 'transform_route.dart';

abstract class TransformRouteHandler<I extends TransformRouteInput, O extends TransformRouteOutput> {
  TransformRouteHandler();

  Future<TransformRouteResponse<O>> execute(I input);

  I inputFromValues(Map<String, dynamic> values);
}
