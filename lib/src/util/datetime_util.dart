class DateTimeUtil {
  static DateTime? decode(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static DateTime decodeNotNull(dynamic value, DateTime defaultValue) {
    if (value == null) return defaultValue;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? defaultValue;
  }

  static String encode(DateTime value) {
    return value.toIso8601String();
  }
}
