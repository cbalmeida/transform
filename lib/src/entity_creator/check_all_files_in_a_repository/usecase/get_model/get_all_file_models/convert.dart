
import 'dart:io';
import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/model/class_model.dart';


class Convert{
  Future<List<ClassModel>> inittialize(List<File> files)async{
    List<ClassModel> classModelList = [];
    for(var r in files){
      ClassModel classModel = ClassModel.fromString(r.readAsStringSync());
      classModelList.add(classModel);
    }
    return classModelList;
  }
}


