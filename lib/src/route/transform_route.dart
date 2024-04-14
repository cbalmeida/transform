import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'transform_route_handler.dart';
part 'transform_route_input.dart';
part 'transform_route_output.dart';
part 'transform_route_response.dart';

enum TransformRouteMethod { get, post, put, delete, patch }

abstract class TransformRoute<I extends TransformRouteInput, O extends TransformRouteOutput> {
  final TransformRouteMethod method;
  final String path;
  final TransformRouteHandler<I, O> handler;

  const TransformRoute({
    required this.method,
    required this.path,
    required this.handler,
  });

  Future<Response> _handleRequest(Request request) async {
    try {
      final Map<String, dynamic> urlParams = request.params;
      final Map<String, dynamic> queryParams = request.url.queryParameters;
      final Map<String, dynamic> bodyParams = jsonDecode(await request.readAsString()) ?? {};
      final Map<String, dynamic> params = {...urlParams, ...queryParams, ...bodyParams};

      final I input = handler.inputFromParams(params);
      final response = await handler.execute(input);
      return response.toResponse();
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  addToRouter(Router router) {
    switch (method) {
      case TransformRouteMethod.get:
        router.get(path, (Request request) => _handleRequest(request));
        break;
      case TransformRouteMethod.post:
        router.post(path, (Request request) => _handleRequest(request));
        break;
      case TransformRouteMethod.put:
        router.put(path, (Request request) => _handleRequest(request));
        break;
      case TransformRouteMethod.delete:
        router.delete(path, (Request request) => _handleRequest(request));
        break;
      case TransformRouteMethod.patch:
        router.patch(path, (Request request) => _handleRequest(request));
        break;
    }
  }
}
