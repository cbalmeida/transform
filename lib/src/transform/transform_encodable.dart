import 'dart:convert';
import 'dart:core';

import '../../transform.dart';

abstract class TransformEncodable {
  const TransformEncodable();

  Object? get encodedValue;

  static TransformEncodableBool fromBool(bool? value) => TransformEncodableBool(value);
  static TransformEncodableInt fromInt(int? value) => TransformEncodableInt(value);
  static TransformEncodableDouble fromDouble(double? value) => TransformEncodableDouble(value);
  static TransformEncodableString fromString(String? value) => TransformEncodableString(value);
  static TransformEncodableDateTime fromDateTime(DateTime? value) => TransformEncodableDateTime(value);
  static TransformEncodableMap fromMap(Map<String, dynamic>? value) => TransformEncodableMap(value);
  static TransformEncodableList fromList(List<dynamic>? value) => TransformEncodableList(value);
  static TransformEncodable fromObject(Object? value) {
    if (value == null) return TransformEncodableString(null);
    if (value is TransformEncodable) return value;
    if (value is bool) return TransformEncodableBool(value);
    if (value is int) return TransformEncodableInt(value);
    if (value is double) return TransformEncodableDouble(value);
    if (value is String) return TransformEncodableString(value);
    if (value is DateTime) return TransformEncodableDateTime(value);
    if (value is Map<String, dynamic>) return TransformEncodableMap(value);
    if (value is List<dynamic>) return TransformEncodableList(value);

    throw Exception('Cannot convert type: ${value.runtimeType} to TransformEncodable');
  }
}

/// bool

class TransformEncodableBool extends TransformEncodable {
  final bool? _value;
  const TransformEncodableBool(this._value);

  @override
  int? get encodedValue => _value == null
      ? null
      : _value == true
          ? 1
          : 0;
}

extension TransformEncodableBoolExtension on bool {
  int? get encodedValue => TransformEncodable.fromBool(this).encodedValue;

  TransformEncodableBool get asEncodable => TransformEncodable.fromBool(this);
}

/// int

class TransformEncodableInt extends TransformEncodable {
  final int? _value;
  const TransformEncodableInt(this._value);

  @override
  int? get encodedValue => _value;
}

extension TransformEncodableIntExtension on int {
  int? get encodedValue => TransformEncodable.fromInt(this).encodedValue;

  TransformEncodableInt get asEncodable => TransformEncodable.fromInt(this);
}

/// double

class TransformEncodableDouble extends TransformEncodable {
  final double? _value;

  const TransformEncodableDouble(this._value);

  @override
  double? get encodedValue => _value;
}

extension TransformEncodableDoubleExtension on double {
  double? get encodedValue => TransformEncodable.fromDouble(this).encodedValue;

  TransformEncodableDouble get asEncodable => TransformEncodable.fromDouble(this);
}

/// String

class TransformEncodableString extends TransformEncodable {
  final String? _value;

  const TransformEncodableString(this._value);

  @override
  String? get encodedValue => _value;
}

extension TransformEncodableStringExtension on String {
  String? get encodedValue => TransformEncodable.fromString(this).encodedValue;

  TransformEncodableString get asEncodable => TransformEncodable.fromString(this);
}

/// DateTime

class TransformEncodableDateTime extends TransformEncodable {
  final DateTime? _value;

  const TransformEncodableDateTime(this._value);

  @override
  String? get encodedValue => _value?.toIso8601String();
}

extension TransformEncodableDateTimeExtension on DateTime {
  String? get encodedValue => TransformEncodable.fromDateTime(this).encodedValue;

  TransformEncodableDateTime get asEncodable => TransformEncodable.fromDateTime(this);
}

/// Map

class TransformEncodableMap extends TransformEncodable {
  final Map<String, dynamic>? _value;

  const TransformEncodableMap(this._value);

  @override
  String? get encodedValue => jsonEncode(_value?.withEncodedValues());
}

extension TransformEncodableMapExtension on Map<String, dynamic> {
  String? get encodedValue => TransformEncodable.fromMap(this).encodedValue;

  Map<String, dynamic> withEncodedValues() => map((key, value) => MapEntry(key, TransformEncodable.fromObject(value).encodedValue));

  bool? valueBool(String key) => BoolUtil.decode(this[key]);
  bool valueBoolNotNull(String key, {bool defaultValue = false}) => BoolUtil.decodeNotNull(this[key], defaultValue);

  int? valueInt(String key) => IntUtil.decode(this[key]);
  int valueIntNotNull(String key, {int defaultValue = 0}) => IntUtil.decodeNotNull(this[key], defaultValue);

  double? valueDouble(String key) => DoubleUtil.decode(this[key]);
  double valueDoubleNotNull(String key, {double defaultValue = 0.0}) => DoubleUtil.decodeNotNull(this[key], defaultValue);

  String? valueString(String key) => StringUtil.decode(this[key]);
  String valueStringNotNull(String key, {String defaultValue = ''}) => StringUtil.decodeNotNull(this[key], defaultValue);

  DateTime? valueDateTime(String key) => DateTimeUtil.decode(this[key]);
  DateTime valueDateTimeNotNull(String key, {DateTime? defaultValue}) => DateTimeUtil.decodeNotNull(this[key], defaultValue ?? DateTime(0));

  Map<String, dynamic>? valueMap(String key) => JsonUtil.decode(this[key]);
  Map<String, dynamic> valueMapNotNull(String key, {Map<String, dynamic> defaultValue = const {}}) => JsonUtil.decodeNotNull(this[key], defaultValue);
}

/// List

class TransformEncodableList extends TransformEncodable {
  final List<dynamic>? _value;

  const TransformEncodableList(this._value);

  @override
  String? get encodedValue => jsonEncode(_value?.withEncodedValues());
}

extension TransformEncodableListExtension on List<dynamic> {
  String? get encodedValue => TransformEncodable.fromList(this).encodedValue;

  TransformEncodableList get asEncodable => TransformEncodable.fromList(this);

  List<dynamic> withEncodedValues() => map((value) => TransformEncodable.fromObject(value).encodedValue).toList();
}
