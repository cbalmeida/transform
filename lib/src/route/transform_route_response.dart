part of 'transform_route.dart';

abstract class TransformRouteResponse<O extends TransformRouteOutput> {
  const TransformRouteResponse();

  Response toResponse();

  // 1xx

  /// 100 — Continue: This interim status code means the server received the initial request, and the client should continue.
  static TransformRouteResponse<O> continueProcess<O extends TransformRouteOutput>(O output) => TransformRouteResponseContinue(output: output);

  /// 101 — Switching Protocols: This code means the requester has asked the server to switch protocols and the server is acknowledging that it will do so.
  static TransformRouteResponse<O> switchingProtocols<O extends TransformRouteOutput>(O output) => TransformRouteResponseSwitchingProtocols(output: output);

  /// 102 — Processing: This code indicates that the server has received and is processing the request, but no response is available yet.
  static TransformRouteResponse<O> processing<O extends TransformRouteOutput>(O output) => TransformRouteResponseProcessing(output: output);

  // 2xx

  /// 200 — OK: It means the request was successful and the server is returning the requested information.
  static TransformRouteResponse<O> ok<O extends TransformRouteOutput>(O output) => TransformRouteResponseOK(output: output);

  /// 201 — Created: This code means the request was successful and the server created a new resource.
  static TransformRouteResponse<O> created<O extends TransformRouteOutput>(O output) => TransformRouteResponseCreated(output: output);

  /// 202 — Accepted: This code means the request was successful, but the processing will finish sometime in the future.
  static TransformRouteResponse<O> accepted<O extends TransformRouteOutput>(O output) => TransformRouteResponseAccepted(output: output);

  /// 203 — Non-Authoritative Information: This code means the server is returning information that might be from another source.
  static TransformRouteResponse<O> nonAuthoritativeInformation<O extends TransformRouteOutput>(O output) => TransformRouteResponseNonAuthoritativeInformation(output: output);

  /// 204 — No Content: This code means the server successfully processed the request but is not returning any content.
  static TransformRouteResponse<O> noContent<O extends TransformRouteOutput>(O output) => TransformRouteResponseNoContent(output: output);

  /// 205 — Reset Content: This code means the server successfully processed the request but is not returning any content.
  static TransformRouteResponse<O> resetContent<O extends TransformRouteOutput>(O output) => TransformRouteResponseResetContent(output: output);

  /// 206 — Partial Content: This code means the server is returning partial data of the size requested.
  static TransformRouteResponse<O> partialContent<O extends TransformRouteOutput>(O output) => TransformRouteResponsePartialContent(output: output);

  /// 207 — Multi-Status: This code means the response is a status message that might be related to multiple requests.
  static TransformRouteResponse<O> multiStatus<O extends TransformRouteOutput>(O output) => TransformRouteResponseMultiStatus(output: output);

  /// 208 — Already Reported: This code means the members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again.
  static TransformRouteResponse<O> alreadyReported<O extends TransformRouteOutput>(O output) => TransformRouteResponseAlreadyReported(output: output);

  /// 226 — IM Used: This code means the server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.
  static TransformRouteResponse<O> imUsed<O extends TransformRouteOutput>(O output) => TransformRouteResponseIMUsed(output: output);

  // 3xx

  /// 300 — Multiple Choices: This code means the server has multiple choices of responses from which the client may choose.
  static TransformRouteResponse<O> multipleChoices<O extends TransformRouteOutput>(O output) => TransformRouteResponseMultipleChoices(output: output);

  /// 301 — Moved Permanently: This code means the resource requested has been assigned a new permanent URI and any future references to this resource should use one of the returned URIs.
  static TransformRouteResponse<O> movedPermanently<O extends TransformRouteOutput>(O output) => TransformRouteResponseMovedPermanently(output: output);

  /// 302 — Found: This code means the server found a temporary redirection.
  static TransformRouteResponse<O> found<O extends TransformRouteOutput>(O output) => TransformRouteResponseFound(output: output);

  /// 303 — See Other: This code means the server is redirecting to another resource.
  static TransformRouteResponse<O> seeOther<O extends TransformRouteOutput>(O output) => TransformRouteResponseSeeOther(output: output);

  /// 304 — Not Modified: This code means the resource has not been modified since the last request.
  static TransformRouteResponse<O> notModified<O extends TransformRouteOutput>(O output) => TransformRouteResponseNotModified(output: output);

  /// 305 — Use Proxy: This code means the requested resource must be accessed by a proxy.
  static TransformRouteResponse<O> useProxy<O extends TransformRouteOutput>(O output) => TransformRouteResponseUseProxy(output: output);

  /// 307 — Temporary Redirect: This code means the server is redirecting to another resource.
  static TransformRouteResponse<O> temporaryRedirect<O extends TransformRouteOutput>(O output) => TransformRouteResponseTemporaryRedirect(output: output);

  /// 308 — Permanent Redirect: This code means the server is redirecting to another resource and the client should use the new URI.
  static TransformRouteResponse<O> permanentRedirect<O extends TransformRouteOutput>(O output) => TransformRouteResponsePermanentRedirect(output: output);

  // 4xx

  /// 400 — Bad Request: This code means the server did not understand the request.
  static TransformRouteResponse<O> badRequest<O extends TransformRouteOutput>(String? message) => TransformRouteResponseBadRequest(message: message);

  /// 401 — Unauthorized: This code means the client must authenticate itself to get the requested response.
  static TransformRouteResponse<O> unauthorized<O extends TransformRouteOutput>(String? message) => TransformRouteResponseUnauthorized(message: message);

  /// 403 — Forbidden: This code means the client does not have the necessary permissions to access the resource.
  static TransformRouteResponse<O> forbidden<O extends TransformRouteOutput>(String? message) => TransformRouteResponseUnauthorized(message: message);

  /// 404 — Not Found: This code means the server could not find the requested resource.
  static TransformRouteResponse<O> notFound<O extends TransformRouteOutput>(String? message) => TransformRouteResponseNotFound(message: message);

  /// 405 — Method Not Allowed: This code means the method used in the request is not allowed.
  static TransformRouteResponse<O> methodNotAllowed<O extends TransformRouteOutput>(String? message) => TransformRouteResponseMethodNotAllowed(message: message);

  /// 406 — Not Acceptable: This code means the server cannot return the requested content type.
  static TransformRouteResponse<O> notAcceptable<O extends TransformRouteOutput>(String? message) => TransformRouteResponseNotAcceptable(message: message);

  /// 408 — Request Timeout: This code means the server timed out waiting for the request.
  static TransformRouteResponse<O> requestTimeout<O extends TransformRouteOutput>(String? message) => TransformRouteResponseRequestTimeout(message: message);

  /// 409 — Conflict: This code means the request could not be processed because of a conflict in the request.
  static TransformRouteResponse<O> conflict<O extends TransformRouteOutput>(String? message) => TransformRouteResponseConflict(message: message);

  /// 410 — Gone: This code means the requested resource is no longer available.
  static TransformRouteResponse<O> gone<O extends TransformRouteOutput>(String? message) => TransformRouteResponseGone(message: message);

  /// 411 — Length Required: This code means the request did not specify the length of its content.
  static TransformRouteResponse<O> lengthRequired<O extends TransformRouteOutput>(String? message) => TransformRouteResponseLengthRequired(message: message);

  /// 412 — Precondition Failed: This code means the server does not meet one of the preconditions that the requester put on the request.
  static TransformRouteResponse<O> preconditionFailed<O extends TransformRouteOutput>(String? message) => TransformRouteResponsePreconditionFailed(message: message);

  /// 413 — Payload Too Large: This code means the request is larger than the server is willing or able to process.
  static TransformRouteResponse<O> payloadTooLarge<O extends TransformRouteOutput>(String? message) => TransformRouteResponsePayloadTooLarge(message: message);

  /// 414 — URI Too Long: This code means the URI provided was too long for the server to process.
  static TransformRouteResponse<O> uriTooLong<O extends TransformRouteOutput>(String? message) => TransformRouteResponseURITooLong(message: message);

  /// 415 — Unsupported Media Type: This code means the server does not support the request content type.
  static TransformRouteResponse<O> unsupportedMediaType<O extends TransformRouteOutput>(String? message) => TransformRouteResponseUnsupportedMediaType(message: message);

  /// 416 — Range Not Satisfiable: This code means the requested range is not available.
  static TransformRouteResponse<O> rangeNotSatisfiable<O extends TransformRouteOutput>(String? message) => TransformRouteResponseRangeNotSatisfiable(message: message);

  /// 417 — Expectation Failed: This code means the server could not meet the requirements of the Expect request-header field.
  static TransformRouteResponse<O> expectationFailed<O extends TransformRouteOutput>(String? message) => TransformRouteResponseExpectationFailed(message: message);

  /// 418 — I'm a teapot: This code means the server refuses to brew coffee because it is a teapot.
  static TransformRouteResponse<O> imATeapot<O extends TransformRouteOutput>(String? message) => TransformRouteResponseImATeapot(message: message);

  /// 421 — Misdirected Request: This code means the request was directed at a server that is not able to produce a response.
  static TransformRouteResponse<O> misdirectedRequest<O extends TransformRouteOutput>(String? message) => TransformRouteResponseMisdirectedRequest(message: message);

  /// 422 — Unprocessable Entity: This code means the server cannot process the request because of semantic errors.
  static TransformRouteResponse<O> unprocessableEntity<O extends TransformRouteOutput>(String? message) => TransformRouteResponseUnprocessableEntity(message: message);

  /// 423 — Locked: This code means the resource that is being accessed is locked.
  static TransformRouteResponse<O> locked<O extends TransformRouteOutput>(String? message) => TransformRouteResponseLocked(message: message);

  /// 424 — Failed Dependency: This code means the request failed because it depended on another request and that request failed.
  static TransformRouteResponse<O> failedDependency<O extends TransformRouteOutput>(String? message) => TransformRouteResponseFailedDependency(message: message);

  /// 425 — Too Early: This code means the server is unwilling to risk processing a request that might be replayed.
  static TransformRouteResponse<O> tooEarly<O extends TransformRouteOutput>(String? message) => TransformRouteResponseTooEarly(message: message);

  /// 426 — Upgrade Required: This code means the server refuses to perform the request using the current protocol but might be willing to do so after the client upgrades to a different protocol.
  static TransformRouteResponse<O> upgradeRequired<O extends TransformRouteOutput>(String? message) => TransformRouteResponseUpgradeRequired(message: message);

  /// 428 — Precondition Required: This code means the server requires the request to be conditional.
  static TransformRouteResponse<O> preconditionRequired<O extends TransformRouteOutput>(String? message) => TransformRouteResponsePreconditionRequired(message: message);

  /// 429 — Too Many Requests: This code means the client has sent too many requests in a given amount of time.
  static TransformRouteResponse<O> tooManyRequests<O extends TransformRouteOutput>(String? message) => TransformRouteResponseTooManyRequests(message: message);

  /// 431 — Request Header Fields Too Large: This code means the server is unwilling to process the request because its header fields are too large.
  static TransformRouteResponse<O> requestHeaderFieldsTooLarge<O extends TransformRouteOutput>(String? message) => TransformRouteResponseRequestHeaderFieldsTooLarge(message: message);

  /// 451 — Unavailable For Legal Reasons: This code means the server is denying access to the resource as a consequence of a legal demand.
  static TransformRouteResponse<O> unavailableForLegalReasons<O extends TransformRouteOutput>(String? message) => TransformRouteResponseUnavailableForLegalReasons(message: message);

  // 5xx

  /// 500 — Internal Server Error: This code means the server encountered an unexpected condition that prevented it from fulfilling the request.
  static TransformRouteResponse<O> internalServerError<O extends TransformRouteOutput>(Exception exception) => TransformRouteResponseInternalServerError(exception: exception);

  /// 501 — Not Implemented: This code means the server does not support the functionality required to fulfill the request.
  static TransformRouteResponse<O> notImplemented<O extends TransformRouteOutput>(String? message) => TransformRouteResponseNotImplemented(message: message);

  /// 502 — Bad Gateway: This code means the server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.
  static TransformRouteResponse<O> badGateway<O extends TransformRouteOutput>(String? message) => TransformRouteResponseBadGateway(message: message);

  /// 503 — Service Unavailable: This code means the server is not ready to handle the request.
  static TransformRouteResponse<O> serviceUnavailable<O extends TransformRouteOutput>(String? message) => TransformRouteResponseServiceUnavailable(message: message);

  /// 504 — Gateway Timeout: This code means the server, while acting as a gateway or proxy, did not receive a timely response from the upstream server specified by the URI or some other auxiliary server it needed to access in order to complete the request.
  static TransformRouteResponse<O> gatewayTimeout<O extends TransformRouteOutput>(String? message) => TransformRouteResponseGatewayTimeout(message: message);

  /// 505 — HTTP Version Not Supported: This code means the server does not support the HTTP protocol version used in the request.
  static TransformRouteResponse<O> httpVersionNotSupported<O extends TransformRouteOutput>(String? message) => TransformRouteResponseHTTPVersionNotSupported(message: message);

  /// 506 — Variant Also Negotiates: This code means the server has an internal configuration error.
  static TransformRouteResponse<O> variantAlsoNegotiates<O extends TransformRouteOutput>(String? message) => TransformRouteResponseVariantAlsoNegotiates(message: message);

  /// 507 — Insufficient Storage: This code means the server is unable to store the representation needed to complete the request.
  static TransformRouteResponse<O> insufficientStorage<O extends TransformRouteOutput>(String? message) => TransformRouteResponseInsufficientStorage(message: message);

  /// 508 — Loop Detected: This code means the server detected an infinite loop while processing the request.
  static TransformRouteResponse<O> loopDetected<O extends TransformRouteOutput>(String? message) => TransformRouteResponseLoopDetected(message: message);

  /// 511 — Network Authentication Required: This code means the client needs to authenticate to gain network access.
  static TransformRouteResponse<O> networkAuthenticationRequired<O extends TransformRouteOutput>(String? message) => TransformRouteResponseNetworkAuthenticationRequired(message: message);
}

// 1xx

class TransformRouteResponseContinue<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseContinue({required this.output});

  @override
  Response toResponse() => Response(100, body: output.body, headers: output.headers);
}

class TransformRouteResponseSwitchingProtocols<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseSwitchingProtocols({required this.output});

  @override
  Response toResponse() => Response(101, body: output.body, headers: output.headers);
}

class TransformRouteResponseProcessing<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseProcessing({required this.output});

  @override
  Response toResponse() => Response(102, body: output.body, headers: output.headers);
}

// 2xx

class TransformRouteResponseOK<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseOK({required this.output});

  @override
  Response toResponse() => Response(200, body: output.body, headers: output.headers);
}

class TransformRouteResponseCreated<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseCreated({required this.output});

  @override
  Response toResponse() => Response(201, body: output.body, headers: output.headers);
}

class TransformRouteResponseAccepted<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseAccepted({required this.output});

  @override
  Response toResponse() => Response(202, body: output.body, headers: output.headers);
}

class TransformRouteResponseNonAuthoritativeInformation<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseNonAuthoritativeInformation({required this.output});

  @override
  Response toResponse() => Response(203, body: output.body, headers: output.headers);
}

class TransformRouteResponseNoContent<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseNoContent({required this.output});

  @override
  Response toResponse() => Response(204, body: output.body, headers: output.headers);
}

class TransformRouteResponseResetContent<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseResetContent({required this.output});

  @override
  Response toResponse() => Response(205, body: output.body, headers: output.headers);
}

class TransformRouteResponsePartialContent<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponsePartialContent({required this.output});

  @override
  Response toResponse() => Response(206, body: output.body, headers: output.headers);
}

class TransformRouteResponseMultiStatus<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseMultiStatus({required this.output});

  @override
  Response toResponse() => Response(207, body: output.body, headers: output.headers);
}

class TransformRouteResponseAlreadyReported<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseAlreadyReported({required this.output});

  @override
  Response toResponse() => Response(208, body: output.body, headers: output.headers);
}

class TransformRouteResponseIMUsed<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseIMUsed({required this.output});

  @override
  Response toResponse() => Response(226, body: output.body, headers: output.headers);
}

// 3xx

class TransformRouteResponseMultipleChoices<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseMultipleChoices({required this.output});

  @override
  Response toResponse() => Response(300, body: output.body, headers: output.headers);
}

class TransformRouteResponseMovedPermanently<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseMovedPermanently({required this.output});

  @override
  Response toResponse() => Response(301, body: output.body, headers: output.headers);
}

class TransformRouteResponseFound<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseFound({required this.output});

  @override
  Response toResponse() => Response(302, body: output.body, headers: output.headers);
}

class TransformRouteResponseSeeOther<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseSeeOther({required this.output});

  @override
  Response toResponse() => Response(303, body: output.body, headers: output.headers);
}

class TransformRouteResponseNotModified<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseNotModified({required this.output});

  @override
  Response toResponse() => Response(304, body: output.body, headers: output.headers);
}

class TransformRouteResponseUseProxy<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseUseProxy({required this.output});

  @override
  Response toResponse() => Response(305, body: output.body, headers: output.headers);
}

class TransformRouteResponseTemporaryRedirect<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponseTemporaryRedirect({required this.output});

  @override
  Response toResponse() => Response(307, body: output.body, headers: output.headers);
}

class TransformRouteResponsePermanentRedirect<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final O output;
  const TransformRouteResponsePermanentRedirect({required this.output});

  @override
  Response toResponse() => Response(308, body: output.body, headers: output.headers);
}

// 4xx

class TransformRouteResponseBadRequest<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseBadRequest({required this.message});

  @override
  Response toResponse() => Response.badRequest(body: {"error": message}.toString());
}

class TransformRouteResponseUnauthorized<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseUnauthorized({required this.message});

  @override
  Response toResponse() => Response.unauthorized({"error": message}.toString());
}

class TransformRouteResponseNotFound<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseNotFound({required this.message});

  @override
  Response toResponse() => Response.notFound({"error": message}.toString());
}

class TransformRouteResponseMethodNotAllowed<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseMethodNotAllowed({required this.message});

  @override
  Response toResponse() => Response(405, body: {"error": message}.toString());
}

class TransformRouteResponseNotAcceptable<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseNotAcceptable({required this.message});

  @override
  Response toResponse() => Response(406, body: {"error": message}.toString());
}

class TransformRouteResponseRequestTimeout<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseRequestTimeout({required this.message});

  @override
  Response toResponse() => Response(408, body: {"error": message}.toString());
}

class TransformRouteResponseConflict<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseConflict({required this.message});

  @override
  Response toResponse() => Response(409, body: {"error": message}.toString());
}

class TransformRouteResponseGone<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseGone({required this.message});

  @override
  Response toResponse() => Response(410, body: {"error": message}.toString());
}

class TransformRouteResponseLengthRequired<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseLengthRequired({required this.message});

  @override
  Response toResponse() => Response(411, body: {"error": message}.toString());
}

class TransformRouteResponsePreconditionFailed<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponsePreconditionFailed({required this.message});

  @override
  Response toResponse() => Response(412, body: {"error": message}.toString());
}

class TransformRouteResponsePayloadTooLarge<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponsePayloadTooLarge({required this.message});

  @override
  Response toResponse() => Response(413, body: {"error": message}.toString());
}

class TransformRouteResponseURITooLong<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseURITooLong({required this.message});

  @override
  Response toResponse() => Response(414, body: {"error": message}.toString());
}

class TransformRouteResponseUnsupportedMediaType<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseUnsupportedMediaType({required this.message});

  @override
  Response toResponse() => Response(415, body: {"error": message}.toString());
}

class TransformRouteResponseRangeNotSatisfiable<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseRangeNotSatisfiable({required this.message});

  @override
  Response toResponse() => Response(416, body: {"error": message}.toString());
}

class TransformRouteResponseExpectationFailed<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseExpectationFailed({required this.message});

  @override
  Response toResponse() => Response(417, body: {"error": message}.toString());
}

class TransformRouteResponseImATeapot<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseImATeapot({required this.message});

  @override
  Response toResponse() => Response(418, body: {"error": message}.toString());
}

class TransformRouteResponseMisdirectedRequest<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseMisdirectedRequest({required this.message});

  @override
  Response toResponse() => Response(421, body: {"error": message}.toString());
}

class TransformRouteResponseUnprocessableEntity<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseUnprocessableEntity({required this.message});

  @override
  Response toResponse() => Response(422, body: {"error": message}.toString());
}

class TransformRouteResponseLocked<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseLocked({required this.message});

  @override
  Response toResponse() => Response(423, body: {"error": message}.toString());
}

class TransformRouteResponseFailedDependency<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseFailedDependency({required this.message});

  @override
  Response toResponse() => Response(424, body: {"error": message}.toString());
}

class TransformRouteResponseTooEarly<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseTooEarly({required this.message});

  @override
  Response toResponse() => Response(425, body: {"error": message}.toString());
}

class TransformRouteResponseUpgradeRequired<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseUpgradeRequired({required this.message});

  @override
  Response toResponse() => Response(426, body: {"error": message}.toString());
}

class TransformRouteResponsePreconditionRequired<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponsePreconditionRequired({required this.message});

  @override
  Response toResponse() => Response(428, body: {"error": message}.toString());
}

class TransformRouteResponseTooManyRequests<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseTooManyRequests({required this.message});

  @override
  Response toResponse() => Response(429, body: {"error": message}.toString());
}

class TransformRouteResponseRequestHeaderFieldsTooLarge<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseRequestHeaderFieldsTooLarge({required this.message});

  @override
  Response toResponse() => Response(431, body: {"error": message}.toString());
}

class TransformRouteResponseUnavailableForLegalReasons<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseUnavailableForLegalReasons({required this.message});

  @override
  Response toResponse() => Response(451, body: {"error": message}.toString());
}

// 5xx

class TransformRouteResponseInternalServerError<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final Exception exception;
  const TransformRouteResponseInternalServerError({required this.exception});

  @override
  Response toResponse() => Response.internalServerError(body: exception.toString());
}

class TransformRouteResponseNotImplemented<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseNotImplemented({required this.message});

  @override
  Response toResponse() => Response(501, body: {"error": message}.toString());
}

class TransformRouteResponseBadGateway<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseBadGateway({required this.message});

  @override
  Response toResponse() => Response(502, body: {"error": message}.toString());
}

class TransformRouteResponseServiceUnavailable<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseServiceUnavailable({required this.message});

  @override
  Response toResponse() => Response(503, body: {"error": message}.toString());
}

class TransformRouteResponseGatewayTimeout<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseGatewayTimeout({required this.message});

  @override
  Response toResponse() => Response(504, body: {"error": message}.toString());
}

class TransformRouteResponseHTTPVersionNotSupported<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseHTTPVersionNotSupported({required this.message});

  @override
  Response toResponse() => Response(505, body: {"error": message}.toString());
}

class TransformRouteResponseVariantAlsoNegotiates<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseVariantAlsoNegotiates({required this.message});

  @override
  Response toResponse() => Response(506, body: {"error": message}.toString());
}

class TransformRouteResponseInsufficientStorage<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseInsufficientStorage({required this.message});

  @override
  Response toResponse() => Response(507, body: {"error": message}.toString());
}

class TransformRouteResponseLoopDetected<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseLoopDetected({required this.message});

  @override
  Response toResponse() => Response(508, body: {"error": message}.toString());
}

class TransformRouteResponseNetworkAuthenticationRequired<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseNetworkAuthenticationRequired({required this.message});

  @override
  Response toResponse() => Response(511, body: {"error": message}.toString());
}

/*
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

class TransformRouteResponseUnauthorized<O extends TransformRouteOutput> extends TransformRouteResponse<O> {
  final String? message;
  const TransformRouteResponseUnauthorized({required this.message});

  @override
  Response toResponse() => Response.unauthorized(message);
}
*/
