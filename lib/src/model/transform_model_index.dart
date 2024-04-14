import '../../transform.dart';

class TransformModelIndex {
  final String name;
  final List<String> columnNames;
  final bool isUnique;

  TransformModelIndex({
    required this.name,
    required this.columnNames,
    this.isUnique = false,
  }) {
    _assertConstructor();
  }

  _assertConstructor() {
    assert(name.isNotEmpty);
    assert(columnNames.isNotEmpty);
  }

  TransformDatabaseIndex get databaseIndex => TransformDatabaseIndex(
        name: name,
        columnNames: columnNames,
        isUnique: isUnique,
      );
}
