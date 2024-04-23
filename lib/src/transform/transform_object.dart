import '../../transform.dart';

class TransformObject<S extends TransformMapped> {
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObject({required this.dataBase, required this.model, required this.adapter}) {
    dataBase.registerTable(model.databaseTable);
  }

  TransformObjectSelect<S> get select => TransformObjectSelect<S>(dataBase: dataBase, model: model, adapter: adapter);

  TransformObjectCount<S> get count => TransformObjectCount<S>(dataBase: dataBase, model: model, adapter: adapter);

  TransformObjectInsert<S> get insert => TransformObjectInsert<S>(dataBase: dataBase, model: model, adapter: adapter);

  TransformObjectUpsert<S> get upsert => TransformObjectUpsert<S>(dataBase: dataBase, model: model, adapter: adapter);

  TransformObjectUpdate<S> get update => TransformObjectUpdate<S>(dataBase: dataBase, model: model, adapter: adapter);
}

class TransformObjectSelect<S extends TransformMapped> {
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectSelect({required this.dataBase, required this.model, required this.adapter});

  TransformDatabaseQueryBuilderSelect<S> builder() => TransformDatabaseQueryBuilderSelect<S>(adapter)..from(model.name);

  TransformDatabaseQueryBuilderSelect<S> where(Map<String, dynamic> whereValues) {
    final builder = this.builder();
    builder.from(model.name);
    List<TransformDatabaseQueryBuilderCondition> conditions = whereValues.entries.map((e) => TransformDatabaseQueryBuilderCondition.equals(e.key, e.value)).toList();
    for (int i = 0; i < conditions.length; i++) {
      if (i == 0) {
        builder.where(conditions[i]);
      } else {
        builder.and(conditions[i]);
      }
    }
    List<TransformDatabaseQueryBuilderOrderBy> orderBy = whereValues.keys.map((e) => TransformDatabaseQueryBuilderOrderBy.asc(e)).toList();
    builder.orderBy(orderBy);
    builder.limit(1);
    return builder;
  }

  TransformDatabaseQueryBuilderSelect<S> all() {
    final builder = this.builder();
    builder.from(model.name);
    return builder;
  }
}

class TransformObjectCount<S extends TransformMapped> extends TransformObject<S> {
  TransformObjectCount({required super.dataBase, required super.model, required super.adapter});

  TransformDatabaseQueryBuilderSelect<int> builder() => TransformDatabaseQueryBuilderSelect<int>(TransformModelAdapterCount())
    ..from(model.name)
    ..columns(["count(*) as count"]);

  TransformDatabaseQueryBuilderSelect<int> all() {
    final builder = this.builder();
    return builder;
  }
}

class TransformObjectInsert<S extends TransformMapped> extends TransformObject<S> {
  TransformObjectInsert({required super.dataBase, required super.model, required super.adapter});

  TransformDatabaseQueryBuilderInsert<S> builder() => TransformDatabaseQueryBuilderInsert<S>(adapter)..into(model.databaseTable);

  TransformDatabaseQueryBuilderInsert<S> values(List<S> values) {
    final builder = this.builder();
    builder.values(values);
    return builder;
  }
}

class TransformObjectUpsert<S extends TransformMapped> extends TransformObject<S> {
  TransformObjectUpsert({required super.dataBase, required super.model, required super.adapter});

  TransformDatabaseQueryBuilderUpsert<S> builder() => TransformDatabaseQueryBuilderUpsert<S>(adapter)..into(model.databaseTable);

  TransformDatabaseQueryBuilderUpsert<S> values(List<S> values) {
    final builder = this.builder();
    builder.values(values);
    return builder;
  }
}

class TransformObjectUpdate<S extends TransformMapped> {
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectUpdate({required this.dataBase, required this.model, required this.adapter});

  TransformDatabaseQueryBuilderUpdate<S> builder() => TransformDatabaseQueryBuilderUpdate<S>(adapter)..table(model.name);

  TransformDatabaseQueryBuilderUpdate<S> where(Map<String, dynamic> whereValues) {
    final builder = this.builder();
    builder.table(model.name);
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
    builder.table(model.name);
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
  final TransformDatabase dataBase;
  final TransformModel model;
  final TransformModelAdapter<S> adapter;

  TransformObjectDelete({required this.dataBase, required this.model, required this.adapter});

  TransformDatabaseQueryBuilderDelete<S> builder() => TransformDatabaseQueryBuilderDelete<S>(adapter)..from(model.name);

  TransformDatabaseQueryBuilderDelete<S> where(Map<String, dynamic> whereValues) {
    final builder = this.builder();
    builder.from(model.name);
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
    builder.from(model.name);
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
