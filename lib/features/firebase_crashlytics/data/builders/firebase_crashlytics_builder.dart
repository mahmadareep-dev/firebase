import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/usecases/enable_collection_usecase.dart';
import '../../domain/usecases/log_usecase.dart';
import '../../domain/usecases/record_error_usecase.dart';
import '../../domain/usecases/record_flutter_error_usecase.dart';
import '../../domain/usecases/set_custom_key_usecase.dart';
import '../../domain/usecases/set_custom_keys_usecase.dart';
import '../../domain/usecases/set_user_id_usecase.dart';

class FirebaseCrashlyticsBuilder {
  FirebaseCrashlyticsBuilder({
    LogUseCase? logUseCase,
    RecordErrorUseCase? recordErrorUseCase,
    RecordFlutterErrorUseCase? recordFlutterErrorUseCase,
    SetUserIdUseCase? setUserIdUseCase,
    SetCustomKeyUseCase? setCustomKeyUseCase,
    SetCustomKeysUseCase? setCustomKeysUseCase,
    EnableCollectionUseCase? enableCollectionUseCase,
  }) : _logUseCase = logUseCase ?? Get.find<LogUseCase>(),
       _recordErrorUseCase =
           recordErrorUseCase ?? Get.find<RecordErrorUseCase>(),
       _recordFlutterErrorUseCase =
           recordFlutterErrorUseCase ?? Get.find<RecordFlutterErrorUseCase>(),
       _setUserIdUseCase = setUserIdUseCase ?? Get.find<SetUserIdUseCase>(),
       _setCustomKeyUseCase =
           setCustomKeyUseCase ?? Get.find<SetCustomKeyUseCase>(),
       _setCustomKeysUseCase =
           setCustomKeysUseCase ?? Get.find<SetCustomKeysUseCase>(),
       _enableCollectionUseCase =
           enableCollectionUseCase ?? Get.find<EnableCollectionUseCase>();

  final LogUseCase _logUseCase;
  final RecordErrorUseCase _recordErrorUseCase;
  final RecordFlutterErrorUseCase _recordFlutterErrorUseCase;
  final SetUserIdUseCase _setUserIdUseCase;
  final SetCustomKeyUseCase _setCustomKeyUseCase;
  final SetCustomKeysUseCase _setCustomKeysUseCase;
  final EnableCollectionUseCase _enableCollectionUseCase;

  Future<Result<void>> log(String message) {
    return _logUseCase(message);
  }

  Future<Result<void>> recordError({
    required Object error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    return _recordErrorUseCase(
      error: error,
      stackTrace: stackTrace,
      fatal: fatal,
    );
  }

  Future<Result<void>> recordFlutterError(FlutterErrorDetails details) {
    return _recordFlutterErrorUseCase(details);
  }

  Future<Result<void>> setUserId(String userId) {
    return _setUserIdUseCase(userId);
  }

  Future<Result<void>> setCustomKey({
    required String key,
    required Object value,
  }) {
    return _setCustomKeyUseCase(key: key, value: value);
  }

  Future<Result<void>> setCustomKeys(Map<String, Object> keys) {
    return _setCustomKeysUseCase(keys);
  }

  Future<Result<void>> enableCollection(bool enabled) {
    return _enableCollectionUseCase(enabled);
  }
}
