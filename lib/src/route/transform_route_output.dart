part of 'transform_route.dart';

abstract class TransformRouteOutput {
  const TransformRouteOutput();

  Object? get body;

  Map<String, Object>? get headers;
}

abstract class TransformRouteOutputString extends TransformRouteOutput {
  const TransformRouteOutputString();

  @override
  Object? get body => output;

  @override
  Map<String, Object>? get headers => {"content-type": "text/plain"};

  String? get output;
}

abstract class TransformRouteOutputJson extends TransformRouteOutput {
  const TransformRouteOutputJson();

  @override
  String? get body => jsonEncode(output);

  @override
  Map<String, Object>? get headers => {"content-type": "application/json"};

  Map<String, dynamic> get output;
}

abstract class TransformRouteOutputStream extends TransformRouteOutput {
  const TransformRouteOutputStream();

  @override
  Object? get body => output;

  @override
  Map<String, Object>? get headers => {"content-type": "application/octet-stream"};

  @override
  Stream? get output;
}

abstract class TransformRouteOutputFileStream extends TransformRouteOutputStream {
  const TransformRouteOutputFileStream();

  @override
  Stream? get output => file.openRead();

  @override
  Map<String, Object>? get headers => {"content-type": "application/octet-stream"};

  File get file;
}
