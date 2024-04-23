class BoolUtil {
  static bool? decode(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      if (value == 'true') return true;
      if (value == '1') return true;
      if (value == 'on') return true;
      if (value == 'yes') return true;
    }
    return bool.tryParse(value.toString());
  }

  static bool decodeNotNull(dynamic value, bool defaultValue) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      if (value == 'true') return true;
      if (value == '1') return true;
      if (value == 'on') return true;
      if (value == 'yes') return true;
    }
    return bool.tryParse(value.toString()) ?? defaultValue;
  }
}
