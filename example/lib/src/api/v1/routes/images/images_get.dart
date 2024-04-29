import 'dart:io';

import 'package:transform/transform.dart';

class ImagesGetRouteInput extends TransformRouteInput {
  final String? fileName;
  const ImagesGetRouteInput({required this.fileName});

  factory ImagesGetRouteInput.fromMap(Map<String, dynamic> map) {
    return ImagesGetRouteInput(fileName: map["file_name"]);
  }
}

class ImagesGetRouteOutput extends TransformRouteOutputFileStream {
  const ImagesGetRouteOutput({required this.file});

  @override
  final File file;

  @override
  Map<String, Object>? get headers => {"content-type": "image/png"};
}

class ImagesGetRouteHandler extends TransformRouteHandler<ImagesGetRouteInput, ImagesGetRouteOutput> {
  ImagesGetRouteHandler({required super.jwt});

  factory ImagesGetRouteHandler.create(TransformInjector injector) {
    return ImagesGetRouteHandler(jwt: injector.get());
  }

  @override
  ImagesGetRouteInput inputFromParams(Map<String, dynamic> params) => ImagesGetRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<ImagesGetRouteOutput>> handler(TransformRouteHandlerInputs<ImagesGetRouteInput> input) async {
    if (input.params.fileName == null) return TransformRouteResponse.badRequest("'file_name' is required!");
    String fileName = input.params.fileName!;

    File file = File("images/$fileName");
    if (!file.existsSync()) return TransformRouteResponse.notFound("file $fileName not found!");

    ImagesGetRouteOutput output = ImagesGetRouteOutput(file: file);
    return TransformRouteResponse.ok(output);
  }
}

class ImagesGetRoute extends TransformRoute<ImagesGetRouteInput, ImagesGetRouteOutput> {
  ImagesGetRoute(super.injector);

  @override
  TransformRouteHandler<ImagesGetRouteInput, ImagesGetRouteOutput> get handler => ImagesGetRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.get;

  @override
  String get path => '/images/<file_name>';
}
