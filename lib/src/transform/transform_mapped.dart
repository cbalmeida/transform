abstract class TransformMapped {
  final Map<String, dynamic> values;

  List<String> get primaryKeyColumns;

  TransformMapped({required this.values});
}
