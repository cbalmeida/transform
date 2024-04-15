import 'package:logger/logger.dart';

class LogUtil {
  static final Logger _logger = Logger();

  static log(String message) => print(message);

  static d(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => _logger.d(message, time: time, error: error, stackTrace: stackTrace);

  static i(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => _logger.i(message, time: time, error: error, stackTrace: stackTrace);

  static e(String message, {DateTime? time, Object? error, StackTrace? stackTrace}) => _logger.e(message, time: time, error: error, stackTrace: stackTrace);
}
