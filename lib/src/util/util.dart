import '../../transform.dart';

class Util {
  static String? stringFromMap(Map<String, dynamic> map, String key) => StringUtil.decode(map[key]);

  static String stringFromMapNotNull(Map<String, dynamic> map, String key, String defaultValue) => StringUtil.decodeNotNull(map[key], defaultValue);

  static int? intFromMap(Map<String, dynamic> map, String key) => IntUtil.decode(map[key]);

  static int intFromMapNotNull(Map<String, dynamic> map, String key, int defaultValue) => IntUtil.decodeNotNull(map[key], defaultValue);

  static double? doubleFromMap(Map<String, dynamic> map, String key) => DoubleUtil.decode(map[key]);

  static double doubleFromMapNotNull(Map<String, dynamic> map, String key, double defaultValue) => DoubleUtil.decodeNotNull(map[key], defaultValue);
}
