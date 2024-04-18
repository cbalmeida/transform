import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'transform_route_handler.dart';
part 'transform_route_input.dart';
part 'transform_route_output.dart';
part 'transform_route_response.dart';

enum TransformRouteMethod {
  get,
  post,
  put,
  delete,
  patch;

  @override
  String toString() {
    switch (this) {
      case TransformRouteMethod.get:
        return "GET";
      case TransformRouteMethod.post:
        return "POST";
      case TransformRouteMethod.put:
        return "PUT";
      case TransformRouteMethod.delete:
        return "DELETE";
      case TransformRouteMethod.patch:
        return "PATCH";
    }
  }
}

abstract class TransformRoute<I extends TransformRouteInput, O extends TransformRouteOutput> {
  final TransformRouteMethod method;
  final String path;
  final TransformRouteHandler<I, O> handler;

  TransformRoute({
    required this.method,
    required this.path,
    required this.handler,
  });

  Future<Map<String, dynamic>> _bodyParams(Request request) async {
    try {
      String body = await request.readAsString();
      if (body.isEmpty) return Future.value({});
      return Future.value(jsonDecode(body));
    } catch (e) {
      return Future.value({});
    }
  }

  Future<Response> _handleRequest(Request request) async {
    try {
      final Map<String, dynamic> urlParams = request.params;
      final Map<String, dynamic> queryParams = request.url.queryParameters;
      final Map<String, dynamic> bodyParams = await _bodyParams(request);
      final Map<String, dynamic> params = {...urlParams, ...queryParams, ...bodyParams};

      final I input = handler.inputFromParams(params);
      final routeResponse = await handler.handler(input);
      Response response = routeResponse.toResponse();
      return response;
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  addToRouter(Router router) => router.add(method.toString(), path, _handleRequest);
}
