import '../../transform.dart';

abstract class TransformMapped extends TransformEncodable {
  const TransformMapped();

  List<String> get primaryKeyColumns;

  Map<String, dynamic> toMap();

  @override
  String? get encodedValue => TransformEncodable.fromMap(toMap()).encodedValue;
}
