import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be printed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 80, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
    ),
  );

  static void d(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void i(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
