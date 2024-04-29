import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.model, required this.adapter}) {
    objects.add(this);
  }

  static final List<TransformObject> objects = [];

  TransformDatabaseColumn columnByName(String name) => model.databaseTable.columnByName(name);

  TransformObjectSelect<S> get select => TransformObjectSelect<S>(model: model, adapter: adapter);

  TransformObjectCount<S> get count => TransformObjectCount<S>(model: model, adapter: adapter);

  TransformObjectInsert<S> get insert => TransformObjectInsert<S>(model: model, adapter: adapter);

  TransformObjectUpsert<S> get upsert => TransformObjectUpsert<S>(model: model, adapter: adapter);

  TransformObjectUpdate<S> get update => TransformObjectUpdate<S>(model: model, adapter: adapter);
}

class TransformObjectSelect<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectSelect({required this.model, required this.adapter});

  TransformDatabaseQueryBuilderSelect<S> builder() => TransformDatabaseQueryBuilderSelect<S>(adapter)..from(model.databaseTable);

  TransformDatabaseQueryBuilderSelect<S> wherePrimaryKey(Map<String, dynamic> primaryKeyValues) {
    List<TransformDatabaseQueryBuilderCondition> conditions = model.databaseTable.primaryKeyConditions(primaryKeyValues);
    TransformDatabaseQueryBuilderSelect<S> builder = where(conditions[0]);
    for (int i = 1; i < conditions.length; i++) {
      builder.and(conditions[i]);
    }
    return builder;
  }

  TransformDatabaseQueryBuilderSelect<S> where(TransformDatabaseQueryBuilderCondition condition) {
    final builder = this.builder();
    builder.from(model.databaseTable);
    builder.where(condition);
    List<TransformDatabaseQueryBuilderOrderBy> orderBy = model.databaseTable.primaryKeyColumns.map((e) => TransformDatabaseQueryBuilderOrderBy.asc(e.name)).toList();
    builder.orderBy(orderBy);
    builder.limit(1);
    return builder;
  }

  TransformDatabaseQueryBuilderSelect<S> all() {
    final builder = this.builder();
    builder.from(model.databaseTable);
    return builder;
  }
}

class TransformObjectCount<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectCount({required this.model, required this.adapter});

  TransformDatabaseQueryBuilderSelect<int> builder() => TransformDatabaseQueryBuilderSelect<int>(TransformModelAdapterCount())
    ..from(model.databaseTable)
    ..columns(["count(*) as count"]);

  TransformDatabaseQueryBuilderSelect<int> all() {
    final builder = this.builder();
    return builder;
  }
}

class TransformObjectInsert<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectInsert({required this.model, required this.adapter});

  TransformDatabaseQueryBuilderInsert<S> builder() => TransformDatabaseQueryBuilderInsert<S>(adapter)..into(model.databaseTable);

  TransformDatabaseQueryBuilderInsert<S> values(List<S> values) {
    final builder = this.builder();
    builder.values(values);
    return builder;
  }
}

class TransformObjectUpsert<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectUpsert({required this.model, required this.adapter});

  TransformDatabaseQueryBuilderUpsert<S> builder() => TransformDatabaseQueryBuilderUpsert<S>(adapter)..into(model.databaseTable);

  TransformDatabaseQueryBuilderUpsert<S> values(List<S> values) {
    final builder = this.builder();
    builder.values(values);
    return builder;
  }
}

class TransformObjectUpdate<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectUpdate({required this.model, required this.adapter});

  TransformDatabaseQueryBuilderUpdate<S> builder() => TransformDatabaseQueryBuilderUpdate<S>(adapter)..table(model.databaseTable);

  TransformDatabaseQueryBuilderUpdate<S> where(Map<String, dynamic> whereValues) {
    final builder = this.builder();
    builder.table(model.databaseTable);
    List<TransformDatabaseQueryBuilderCondition> conditions = whereValues.entries.map((e) => TransformDatabaseQueryBuilderCondition.equals(e.key, e.value)).toList();
    for (int i = 0; i < conditions.length; i++) {
      if (i == 0) {
        builder.where(conditions[i]);
      } else {
        builder.and(conditions[i]);
      }
    }
    return builder;
  }

  TransformDatabaseQueryBuilderUpdate<S> set(S value) {
    final builder = this.builder();
    builder.table(model.databaseTable);
    builder.set(adapter.toMap(value));
    Map<String, dynamic> mappedValues = adapter.toMap(value);
    Map<String, dynamic> whereValues = {};
    for (TransformModelColumn column in model.primaryKeyColumns) {
      dynamic value = mappedValues[column.name];
      whereValues[column.name] = value;
    }
    List<TransformDatabaseQueryBuilderCondition> conditions = whereValues.entries.map((e) => TransformDatabaseQueryBuilderCondition.equals(e.key, e.value)).toList();
    for (int i = 0; i < conditions.length; i++) {
      if (i == 0) {
        builder.where(conditions[i]);
      } else {
        builder.and(conditions[i]);
      }
    }
    return builder;
  }
}

class TransformObjectDelete<S extends TransformMapped> {
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectDelete({required this.model, required this.adapter});

  TransformDatabaseQueryBuilderDelete<S> builder() => TransformDatabaseQueryBuilderDelete<S>(adapter)..from(model.databaseTable);

  TransformDatabaseQueryBuilderDelete<S> where(Map<String, dynamic> whereValues) {
    final builder = this.builder();
    builder.from(model.databaseTable);
    List<TransformDatabaseQueryBuilderCondition> conditions = whereValues.entries.map((e) => TransformDatabaseQueryBuilderCondition.equals(e.key, e.value)).toList();
    for (int i = 0; i < conditions.length; i++) {
      if (i == 0) {
        builder.where(conditions[i]);
      } else {
        builder.and(conditions[i]);
      }
    }
    return builder;
  }

  TransformDatabaseQueryBuilderDelete<S> value(S value) {
    final builder = this.builder();
    builder.from(model.databaseTable);
    Map<String, dynamic> mappedValues = adapter.toMap(value);
    Map<String, dynamic> whereValues = {};
    for (TransformModelColumn column in model.primaryKeyColumns) {
      dynamic value = mappedValues[column.name];
      whereValues[column.name] = value;
    }
    List<TransformDatabaseQueryBuilderCondition> conditions = whereValues.entries.map((e) => TransformDatabaseQueryBuilderCondition.equals(e.key, e.value)).toList();
    for (int i = 0; i < conditions.length; i++) {
      if (i == 0) {
        builder.where(conditions[i]);
      } else {
        builder.and(conditions[i]);
      }
    }
    return builder;
  }
}
