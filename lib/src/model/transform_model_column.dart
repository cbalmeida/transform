import '../../transform.dart';

class TransformModelColumn {
  final String name;
  final TransformModelColumnType type;
  final bool isNullable;
  final dynamic defaultValue;
  final bool isPrimaryKey;
  final bool isUnique;

  TransformModelColumn({
    required this.name,
    required this.type,
    this.isNullable = false,
    this.defaultValue,
    this.isPrimaryKey = false,
    this.isUnique = false,
  });

  TransformDatabaseColumn get databaseColumn => TransformDatabaseColumn(
        name: name,
        type: type.databaseColumnType,
        isNullable: isNullable,
        defaultValue: defaultValue,
        isPrimaryKey: isPrimaryKey,
        isUnique: isUnique,
      );
}
