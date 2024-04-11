abstract class TransformModelAdapter<S> {
  S fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap(S model);
}
