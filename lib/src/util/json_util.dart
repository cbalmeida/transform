import 'dart:convert';

class JsonUtil {
  static Map<String, dynamic>? decode(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    try {
      if (value is String) return Map<String, dynamic>.from(jsonDecode(value));
      return Map<String, dynamic>.from(value);
    } catch (e) {
      return null;
    }
  }

  static Map<String, dynamic> decodeNotNull(dynamic value, Map<String, dynamic> defaultValue) {
    if (value == null) return defaultValue;
    if (value is Map<String, dynamic>) return value;
    try {
      if (value is String) return Map<String, dynamic>.from(jsonDecode(value));
      return Map<String, dynamic>.from(value);
    } catch (e) {
      return defaultValue;
    }
  }

  static String encodeAsJsonErrorMessage(String message) {
    return jsonEncode({"error": message});
  }
}
