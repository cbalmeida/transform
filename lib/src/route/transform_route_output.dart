part of 'transform_route.dart';

abstract class TransformRouteOutput {
  const TransformRouteOutput();

  Map<String, dynamic> toMap();

  String toJson() => jsonEncode(toMap());
}
