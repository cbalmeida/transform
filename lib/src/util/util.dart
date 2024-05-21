import 'dart:math';

import '../../transform.dart';

class Util {
  /*
  static String? stringFromMap(Map<String, dynamic> map, String key) => StringUtil.decode(map[key]);

  static String stringFromMapNotNull(Map<String, dynamic> map, String key, String defaultValue) => StringUtil.decodeNotNull(map[key], defaultValue);

  static int? intFromMap(Map<String, dynamic> map, String key) => IntUtil.decode(map[key]);

  static int intFromMapNotNull(Map<String, dynamic> map, String key, int defaultValue) => IntUtil.decodeNotNull(map[key], defaultValue);

  static double? doubleFromMap(Map<String, dynamic> map, String key) => DoubleUtil.decode(map[key]);

  static double doubleFromMapNotNull(Map<String, dynamic> map, String key, double defaultValue) => DoubleUtil.decodeNotNull(map[key], defaultValue);

  static bool? boolFromMap(Map<String, dynamic> map, String key) => BoolUtil.decode(map[key]);

  static bool boolFromMapNotNull(Map<String, dynamic> map, String key, bool defaultValue) => BoolUtil.decodeNotNull(map[key], defaultValue);

  static DateTime? dateTimeFromMap(Map<String, dynamic> map, String key) => DateTimeUtil.decode(map[key]);

  static DateTime dateTimeFromMapNotNull(Map<String, dynamic> map, String key, DateTime defaultValue) => DateTimeUtil.decodeNotNull(map[key], defaultValue);

  static Map<String, dynamic>? mapFromMap(Map<String, dynamic> map, String key) => JsonUtil.decode(map[key]);

  static Map<String, dynamic> mapFromMapNotNull(Map<String, dynamic> map, String key, Map<String, dynamic> defaultValue) => JsonUtil.decodeNotNull(map[key], defaultValue);

  static Object? toEncodable(Object? object) {
    if (object == null) return null;
    if (object is String) return object;
    if (object is int) return object;
    if (object is double) return object;
    if (object is bool) return object.encode();
    if (object is DateTime) return object.encode();
    return object;
  }

  static Object? encode(Object? object) => jsonEncode(toEncodable(object));

  //static Map<String, dynamic>? jsonTimeFromMap(Map<String, dynamic> map, String key) => JsonUtil.decode(map[key]);

  //static Map<String, dynamic> jsonTimeFromMapNotNull(Map<String, dynamic> map, String key, Map<String, dynamic> defaultValue) => JsonUtil.decodeNotNull(map[key], defaultValue);
  */

  static String encodeAsJsonErrorMessage(String message) => JsonUtil.encodeAsJsonErrorMessage(message);

  static void logDebug(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.d(message, time: time, error: error, stackTrace: stackTrace);

  static void logInfo(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.i(message, time: time, error: error, stackTrace: stackTrace);

  static void logError(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.e(message, time: time, error: error, stackTrace: stackTrace);

  static void log(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.log(message);

  static String hashPassword(String password) => BCrypt.hashpw(password, BCrypt.gensalt());

  static bool checkPassword(String password, String hashedPassword) => BCrypt.checkpw(password, hashedPassword);

  static int generateRandomAlphanumericCharCode() {
    var random = Random.secure();
    while (true) {
      final value = random.nextInt(122);
      if (value >= 48 && value <= 57) return value;
      if (value >= 65 && value <= 90) return value;
      if (value >= 97 && value <= 122) return value;
    }
  }

  static int generateRandomNumericCharCode() {
    var random = Random.secure();
    while (true) {
      final value = random.nextInt(57);
      if (value >= 48 && value <= 57) return value;
    }
  }

  static String generateRandomAlphanumericString(int length) {
    var values = List<int>.generate(length, (i) => generateRandomAlphanumericCharCode());
    return String.fromCharCodes(values);
  }

  static String generateRandomNumericString(int length) {
    var values = List<int>.generate(length, (i) => generateRandomNumericCharCode());
    return String.fromCharCodes(values);
  }

  static String generateVerificationToken() => generateRandomAlphanumericString(36);

  static String generateVerificationCode() => generateRandomNumericString(6);
}
