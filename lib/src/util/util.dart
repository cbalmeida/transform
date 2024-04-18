import '../../transform.dart';

class Util {
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

  static Map<String, dynamic>? jsonTimeFromMap(Map<String, dynamic> map, String key) => JsonUtil.decode(map[key]);

  static Map<String, dynamic> jsonTimeFromMapNotNull(Map<String, dynamic> map, String key, Map<String, dynamic> defaultValue) => JsonUtil.decodeNotNull(map[key], defaultValue);

  static void logDebug(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.d(message, time: time, error: error, stackTrace: stackTrace);

  static void logInfo(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.i(message, time: time, error: error, stackTrace: stackTrace);

  static void logError(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.e(message, time: time, error: error, stackTrace: stackTrace);

  static void log(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => LogUtil.log(message);
}
