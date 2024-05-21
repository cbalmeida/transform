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
      final responseMaxRequests = handler.checkMaxRequests(request);
      if (responseMaxRequests != null) return responseMaxRequests;

      final Map<String, dynamic> urlParams = request.params;
      final Map<String, dynamic> queryParams = request.url.queryParameters;
      final Map<String, dynamic> bodyParams = await _bodyParams(request);
      final Map<String, dynamic> params = {...urlParams, ...queryParams, ...bodyParams};

      final checkToken = handler.checkToken(request);
      if (checkToken.isLeft) return Response.forbidden("Invalid token: ${checkToken.left}");
      TransformJWTPayload tokenPayload = checkToken.right;

      final I input = handler.inputFromParams(params);
      final TransformRouteHandlerInputs<I> handlerInputs = TransformRouteHandlerInputs(params: input, tokenPayload: tokenPayload);
      return Isolate.run(() => handler.handler(handlerInputs)).then((value) => value.toResponse());
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  addToRouter(Router router) => router.add(method.toString(), path, _handleRequest);
}

class TransformRouteLimiterParams {
  final int maxRequests;
  final int timeFrameInSeconds;

  TransformRouteLimiterParams({required this.maxRequests, required this.timeFrameInSeconds});

  factory TransformRouteLimiterParams.fromEnvironment() {
    int maxRequests = const int.fromEnvironment('ROUTERLIMITER_MAX_REQUESTS', defaultValue: 10);
    int timeFrameInSeconds = const int.fromEnvironment('ROUTERLIMITER_TIME_FRAME_IN_SECONDS', defaultValue: 5);
    return TransformRouteLimiterParams(maxRequests: maxRequests, timeFrameInSeconds: timeFrameInSeconds);
  }

  factory TransformRouteLimiterParams.fromMap(Map<String, dynamic> map) {
    int maxRequests = map.valueIntNotNull('ROUTERLIMITER_MAX_REQUESTS', defaultValue: 10);
    int timeFrameInSeconds = map.valueIntNotNull('ROUTERLIMITER_TIME_FRAME_IN_SECONDS', defaultValue: 5);
    return TransformRouteLimiterParams(maxRequests: maxRequests, timeFrameInSeconds: timeFrameInSeconds);
  }

  factory TransformRouteLimiterParams.fromValues({required int maxRequests, required int timeFrameInSeconds}) {
    return TransformRouteLimiterParams(maxRequests: maxRequests, timeFrameInSeconds: timeFrameInSeconds);
  }
}

class TransformRouteLimiter {
  final TransformRouteLimiterParams params;

  TransformRouteLimiter(this.params);

  Map<String, List<int>> requestHistory = {};

  void addRequest(String ip) {
    List<int> ipRequests = requestHistory[ip] ?? [];
    ipRequests.add(DateTime.now().millisecondsSinceEpoch);
    requestHistory[ip] = ipRequests;
  }

  bool isIpBlocked(String ip) {
    cleanUpIp(ip);
    final ipRequests = requestHistory[ip] ?? [];
    final response = ipRequests.length > params.maxRequests;
    if (!response) addRequest(ip);
    return response;
  }

  void cleanUpIp(String ip) {
    List<int> ipRequests = requestHistory[ip] ?? [];
    if (ipRequests.isEmpty) {
      requestHistory.remove(ip);
      return;
    }
    int lastMinute = DateTime.now().millisecondsSinceEpoch - params.timeFrameInSeconds * 1000;
    ipRequests.removeWhere((requestTime) => requestTime < lastMinute);
    requestHistory[ip] = ipRequests;
  }

  void cleanUpAll() {
    for (String ip in requestHistory.keys) {
      cleanUpIp(ip);
    }
    requestHistory.removeWhere((key, value) => value.isEmpty);
  }
}
