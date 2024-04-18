

import 'package:transform/src/entity_creator/check_all_files_in_a_repository/usecase/get_model/model/class_model_column.dart';

class ClassModel {
  final String classe;
  final String name;
  final String schema;
  final List<ClassModelColumn> columns;

  ClassModel({required this.name, required this.schema, required this.classe, required this.columns});

  factory ClassModel.fromString(String res){
    String classe = '';
    String name = '';
    String schema = '';
    List<ClassModelColumn> columns = [];
    List<String> t = res.split('\n');
    for(int i = 0 ; i < t.length ; i++){
      if(t[i].contains("class")){
        List e = t[i].split(' ');
        if(e[1].toString().toLowerCase().contains("model")){
          List w = e[1].toString().toLowerCase().split("model");
          classe = w[0];
        }else{
          classe = e[1];
        }
      }
    }

    final List<String> u = res.split('@override');
    u.removeAt(0);

    for(var i in u){
      if(i.contains("String") && i.contains("name")){
        String s = i;
        name = s.replaceAll(RegExp('String'), '').replaceAll(RegExp('get'), '').replaceAll(RegExp('name'), '').replaceAll(RegExp('return'), '').replaceAll(RegExp('[}{ \n =>;]'), '');
      }
      if(i.contains("String") && i.contains("schema")){
        String s = i;
        schema = s.replaceAll(RegExp('String'), '').replaceAll(RegExp('get'), '').replaceAll(RegExp('schema'), '').replaceAll(RegExp('return'), '').replaceAll(RegExp('[}{ \n =>;]'), '');
      }



      if(i.contains("TransformModelColumn") && i.contains("columns")){
        String s = i;
        String columnsResponse = s.replaceAll(RegExp(' '), '');
        List<String> g = columnsResponse.split("TransformModelColumn(");
        g.removeAt(0);
        for(var te in g){
          String rr = te.replaceAll(RegExp(r'];'), '').replaceAll(RegExp(r'\),'), '').replaceAll(RegExp(r'\('), '(),');
          List<String> rrresponse = rr.split(',');
          ClassModelColumn classModelColumn = ClassModelColumn.fromString(rrresponse);
          columns.add(classModelColumn);
      
        }
      }
    }

    return ClassModel(name: name, schema: schema, classe: classe, columns: columns);
    
  }
  
}
