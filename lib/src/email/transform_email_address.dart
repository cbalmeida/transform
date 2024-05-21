import 'dart:convert';

import '../../transform.dart';

class TransformEmailAddress extends TransformMapped {
  final String email;
  final String name;

  TransformEmailAddress({required this.email, this.name = ""});

  @override
  Map<String, dynamic> toMap() => {
        "email": email,
        "name": name,
      };

  String toJson() {
    Map<String, dynamic> map = toMap();
    String json = jsonEncode(map);
    return json;
  }

  factory TransformEmailAddress.fromMap(Map<String, dynamic> map) => TransformEmailAddress(
        email: map.valueStringNotNull('email'),
        name: map.valueStringNotNull('name'),
      );

  factory TransformEmailAddress.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return TransformEmailAddress.fromMap(map);
  }

  static List<TransformEmailAddress> fromJsonList(String json) => jsonDecode(json).map<TransformEmailAddress>((e) => TransformEmailAddress.fromMap(e)).toList();

  @override
  List<String> get primaryKeyColumns => ['email'];
}
