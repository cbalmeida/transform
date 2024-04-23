import 'dart:io';
import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/create_model.dart/create_model.dart';
import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/get_all_file_models/convert.dart';
import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/get_files.dart';
import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/model/class_model.dart';

class GetAllFilesModels implements GetFiles{

  Directory diretorio = Directory('example/lib/src/models/');
  List<ClassModel> classModelList = [];

  GetAllFilesModels(){
    getFiles();
  }

  @override
  void getFiles() {
    List<File> fileDart = [];
    if (diretorio.existsSync()) {
      diretorio.listSync(recursive: true).forEach((entity) {
        if (entity is File && entity.path.endsWith('.dart')) {
          fileDart.add(entity);
        }
      });
      convertFiles(fileDart);
    } else {
      print('O diretório não existe.');
    }
  }

  @override
  void convertFiles(List<File> files)async{
    classModelList = await Convert().inittialize(files);
    createFiles();
  }

  
  @override
  void createFiles() {
    CreateModels().initialize(classModelList);
  }



}
