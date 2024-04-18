import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/get_all_file_models/get_all_files_model.dart';
import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/get_files.dart';

class Create{
  createModel(){
    GetFiles getAllFilesModel = GetAllFilesModels();
    getAllFilesModel.inicialize();
  }
}







void main(List<String> args) {
  Create get = Create();
  get.createModel();
}

