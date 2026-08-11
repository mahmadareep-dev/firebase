import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract interface class CrashlyticsRemoteDataSource {
  Future<void> log(String message);

  Future<void> recordError({
    required Object error,
    StackTrace? stackTrace,
    bool fatal = false,
  });

  Future<void> recordFlutterError(FlutterErrorDetails details);

  Future<void> setUserId(String userId);

  Future<void> setCustomKey({required String key, required Object value});

  Future<void> setCustomKeys(Map<String, Object> keys);

  Future<void> enableCollection(bool enabled);
}

class CrashlyticsRemoteDataSourceImpl implements CrashlyticsRemoteDataSource {
  const CrashlyticsRemoteDataSourceImpl();

  @override
  Future<void> log(String message) {
    return FirebaseCrashlytics.instance.log(message);
  }

  @override
  Future<void> recordError({
    required Object error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    return FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      fatal: fatal,
    );
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) {
    return FirebaseCrashlytics.instance.recordFlutterError(details);
  }

  @override
  Future<void> setUserId(String userId) {
    return FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  @override
  Future<void> setCustomKey({required String key, required Object value}) {
    return FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  @override
  Future<void> setCustomKeys(Map<String, Object> keys) async {
    for (final entry in keys.entries) {
      await FirebaseCrashlytics.instance.setCustomKey(entry.key, entry.value);
    }
  }

  @override
  Future<void> enableCollection(bool enabled) {
    return FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      enabled,
    );
  }
}
