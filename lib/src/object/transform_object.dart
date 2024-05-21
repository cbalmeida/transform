import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  static final List<TransformObject> objects = [];

  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.model, required this.adapter}) {
    objects.add(this);
  }

  late final TransformDatabaseTable<S> databaseTable = TransformDatabaseTable<S>(
    adapter: adapter,
    name: model.name,
    schema: model.schema,
    columns: model.columns.map((e) => e.databaseColumn).toList(),
    indexes: model.indexes.map((e) => e.databaseIndex).toList(),
    initialData: model.initialData,
  );
}
