import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class LoggerService {
  LoggerService._();

  static void debug(Object? message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      developer.log(message.toString(), name: tag);
    }
  }

  static void info(Object? message, {String tag = 'INFO'}) {
    developer.log(message.toString(), name: tag);
  }

  static void warning(Object? message, {String tag = 'WARNING'}) {
    developer.log(message.toString(), name: tag);
  }

  static void error(
    Object? message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'ERROR',
  }) {
    developer.log(
      message.toString(),
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
