class TransformDatabaseIndex {
  final String name;
  final List<String> columnNames;
  final bool isUnique;

  TransformDatabaseIndex({
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
}
