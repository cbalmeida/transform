import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../transform.dart';

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
  final TransformInjector injector;

  TransformRoute(this.injector);

  TransformRouteMethod get method;
  String get path;
  TransformRouteHandler<I, O> get handler;

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

      TransformJWTPayload? tokenPayload;
      if (handler.checkToken) {
        final String token = request.headers["Authorization"] ?? request.url.queryParameters["token"] ?? "";
        TransformEither<Exception, TransformJWTPayload> decodedToken = handler.decodeToken(token);
        if (decodedToken.isLeft) return Response.forbidden("Invalid token: ${decodedToken.left}");
        tokenPayload = decodedToken.right;
      }

      final I input = handler.inputFromParams(params);
      final TransformRouteHandlerInputs<I> handlerInputs = TransformRouteHandlerInputs(params: input, tokenPayload: tokenPayload ?? TransformJWTPayload.empty());
      return Isolate.run(() => handler.handler(handlerInputs)).then((TransformRouteResponse<O> routeResponse) {
        Response response = routeResponse.toResponse();
        return response;
      });
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  addToRouter(Router router) => router.add(method.toString(), path, _handleRequest);
}
