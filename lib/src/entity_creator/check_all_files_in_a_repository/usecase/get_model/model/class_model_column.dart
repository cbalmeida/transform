
class ClassModelColumn {
  final String name;
  final String type;
  final String isNullable;
  final String defaultValue;
  final String isPrimaryKey;
  final String isUnique;

  ClassModelColumn({required this.name, required this.type, required this.isNullable, required this.defaultValue, required this.isPrimaryKey, required this.isUnique});

  factory ClassModelColumn.fromString(List<String> response){
    List<String> namelocal = response.where((element) => element.contains("name:")).toList();
    List<String> typelocal = response.where((element) => element.contains("type:")).toList();
    List<String> isNullablelocal = response.where((element) => element.contains("isNullable:")).toList();
    List<String> defaultValuelocal = response.where((element) => element.contains("defaultValue:")).toList();
    List<String> isPrimaryKeylocal = response.where((element) => element.contains("isPrimaryKey:")).toList();
    List<String> isUniquelocal = response.where((element) => element.contains("isUnique:")).toList();

    final String name = namelocal.isNotEmpty ? namelocal.first.replaceAll(RegExp(r'name:'), '') : "";
    final String type = typelocal.isNotEmpty ? typelocal.first.replaceAll(RegExp(r'type:'), '') : "";
    final String isNullable = isNullablelocal.isNotEmpty ? isNullablelocal.first.replaceAll(RegExp(r'isNullable:'), '') : "";
    final String defaultValue = defaultValuelocal.isNotEmpty ? defaultValuelocal.first.replaceAll(RegExp(r'defaultValue:'), '') : "";
    final String isPrimaryKey = isPrimaryKeylocal.isNotEmpty ? isPrimaryKeylocal.first.replaceAll(RegExp(r'isPrimaryKey:'), '') : "";
    final String isUnique = isUniquelocal.isNotEmpty ? isUniquelocal.first.replaceAll(RegExp(r'isUnique:'), '') : "";
    return ClassModelColumn(name: name, type: type, isNullable: isNullable, defaultValue: defaultValue, isPrimaryKey: isPrimaryKey, isUnique: isUnique);
  }


  String get getTemplate{
    String getTypeLocal = getType();
    String isNullableLocal = getIsNullable();
    String defaultValueLocal = getDefaultValue();
    return '''$getTypeLocal$isNullableLocal get ${name.replaceAll(RegExp('"'), '')} => Util.${getTypeLocal.toLowerCase()}FromMap${getUtilType(isNullableLocal)}(values, '${name.replaceAll(RegExp('"'), '')}'$defaultValueLocal);
set ${name.replaceAll(RegExp('"'), '')}($getTypeLocal$isNullableLocal value) => values['${name.replaceAll(RegExp('"'), '')}'] = value;''';
  }

  String getDefaultValue(){
    if(defaultValue == ''){
      return '';
    }else{
      return r', ""';
    }
  }

  String getUtilType(String t){
    if(t == "?"){
      return '';
    }else{
      return 'NotNull';
    }
  }


  String getType(){
    if(type == "TransformModelColumnTypeUUID()"){
      return "String";
    }else if(type == "TransformModelColumnTypeMonetary()"){
      return "double";
    }else if(type == "TransformModelColumnTypeInteger()"){
      return "int";
    }else if(type == "TransformModelColumnTypeText()"){
      return "String";
    }else{
      return "String";
    }
  }

  String getIsNullable(){
    if(isNullable.contains("true")){
      return "?";
    }else{
      return '';
    }
  }


}