import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';

abstract interface class FirebaseCrashlyticsRepository {
  Future<Result<void>> log(String message);

  Future<Result<void>> recordError({
    required Object error,
    StackTrace? stackTrace,
    bool fatal = false,
  });

  Future<Result<void>> recordFlutterError(FlutterErrorDetails details);

  Future<Result<void>> setUserId(String userId);

  Future<Result<void>> setCustomKey({
    required String key,
    required Object value,
  });

  Future<Result<void>> setCustomKeys(Map<String, Object> keys);

  Future<Result<void>> enableCollection(bool enabled);
}
