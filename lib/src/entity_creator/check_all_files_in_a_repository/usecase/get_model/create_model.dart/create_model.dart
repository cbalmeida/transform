import 'dart:io';

import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/model/class_model.dart';

class CreateModels{
  String novoDiretorio = 'example/lib/generated/objects/models';
  List<ClassModel> classModelList = [];

  void initialize(List<ClassModel> v){
    classModelList = v;
    createDirectory();
  }

  void createDirectory(){
    Directory(novoDiretorio).create(recursive: true)
    .then((Directory directory) {
      print('Pasta criada com sucesso: ${directory.path}');
      createFile();
    })
    .catchError((e) {
      print('Erro ao criar a pasta: $e');
    });
  }


  void createFile()async{
    for(var i in classModelList){
      String body = '';
      body += '\n';
      for(var e in i.columns){
        body += e.getTemplate;
        body += '\n';
      }
        var arquivo = File("$novoDiretorio/${i.classe}.dart");
await arquivo.writeAsString('''
import 'package:transform/transform.dart';
 
class ${firstLetterCapitalized(i.classe)} extends TransformMapped {
  ${firstLetterCapitalized(i.classe)}({required super.values});

$body

}

class ${firstLetterCapitalized(i.classe)}Adapter extends TransformModelAdapter<${firstLetterCapitalized(i.classe)}> {
  @override
  ${firstLetterCapitalized(i.classe)} fromMap(Map<String, dynamic> map) => ${firstLetterCapitalized(i.classe)}(values: map);

  @override
  Map<String, dynamic> toMap(${firstLetterCapitalized(i.classe)} model) => model.values;
}

class ${firstLetterCapitalized(i.classe)}Object extends TransformObject<${firstLetterCapitalized(i.classe)}> {
  ${firstLetterCapitalized(i.classe)}Object({required super.dataBase}) : super(model: ${firstLetterCapitalized(i.classe)}Model(), adapter: ${firstLetterCapitalized(i.classe)}Adapter());
}


''');
    }

  
  }


  String firstLetterCapitalized(String v){
    String value = v.substring(0, 1).toUpperCase();
    value += v.substring(1, v.length);
    return value;
  }


}


