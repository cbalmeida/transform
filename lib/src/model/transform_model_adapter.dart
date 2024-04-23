abstract class TransformModelAdapter<S> {
  S fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap(S model);

  static TransformModelAdapterCount count() => TransformModelAdapterCount();
}

class TransformModelAdapterCount extends TransformModelAdapter<int> {
  @override
  int fromMap(Map<String, dynamic> map) {
    return map['count'];
  }

  @override
  Map<String, dynamic> toMap(int model) {
    return {'count': model};
  }
}
