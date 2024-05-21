import 'dart:io';

import 'package:transform/transform.dart';

class GetImagesRouteInput extends TransformRouteInput {
  final String? fileName;
  const GetImagesRouteInput({required this.fileName});

  factory GetImagesRouteInput.fromMap(Map<String, dynamic> map) {
    return GetImagesRouteInput(fileName: map["file_name"]);
  }
}

class GetImagesRouteOutput extends TransformRouteOutputFileStream {
  const GetImagesRouteOutput({required this.file});

  @override
  final File file;

  @override
  Map<String, Object>? get headers => {"content-type": "image/png"};
}

class GetImagesRouteHandler extends TransformRouteHandler<GetImagesRouteInput, GetImagesRouteOutput> {
  GetImagesRouteHandler({required super.jwt, required super.limiter});

  factory GetImagesRouteHandler.create(TransformInjector injector) {
    return GetImagesRouteHandler(
      jwt: injector.get(),
      limiter: injector.get(),
    );
  }

  @override
  GetImagesRouteInput inputFromParams(Map<String, dynamic> params) => GetImagesRouteInput.fromMap(params);

  @override
  Future<TransformRouteResponse<GetImagesRouteOutput>> handler(TransformRouteHandlerInputs<GetImagesRouteInput> input) async {
    if (input.params.fileName == null) return TransformRouteResponse.badRequest("'file_name' is required!");
    String fileName = input.params.fileName!;

    File file = File("images/$fileName");
    if (!file.existsSync()) return TransformRouteResponse.notFound("file $fileName not found!");

    GetImagesRouteOutput output = GetImagesRouteOutput(file: file);
    return TransformRouteResponse.ok(output);
  }
}

class GetImagesRoute extends TransformRoute<GetImagesRouteInput, GetImagesRouteOutput> {
  GetImagesRoute(super.injector);

  @override
  TransformRouteHandler<GetImagesRouteInput, GetImagesRouteOutput> get handler => GetImagesRouteHandler.create(injector);

  @override
  TransformRouteMethod get method => TransformRouteMethod.get;

  @override
  String get path => '/images/<file_name>';
}
