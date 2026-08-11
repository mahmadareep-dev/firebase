import 'package:flutter/cupertino.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/firebase_crashlytics_repository.dart';
import '../datasources/crashlytics_remote_data_source.dart';

class FirebaseCrashlyticsRepositoryImpl
    implements FirebaseCrashlyticsRepository {
  FirebaseCrashlyticsRepositoryImpl(this._remote);

  final CrashlyticsRemoteDataSource _remote;

  @override
  Future<Result<void>> log(String message) async {
    try {
      await _remote.log(message);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> recordError({
    required Object error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) async {
    try {
      await _remote.recordError(
        error: error,
        stackTrace: stackTrace,
        fatal: fatal,
      );

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> recordFlutterError(FlutterErrorDetails details) async {
    try {
      await _remote.recordFlutterError(details);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setUserId(String userId) async {
    try {
      await _remote.setUserId(userId);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setCustomKey({
    required String key,
    required Object value,
  }) async {
    try {
      await _remote.setCustomKey(key: key, value: value);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setCustomKeys(Map<String, Object> keys) async {
    try {
      await _remote.setCustomKeys(keys);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> enableCollection(bool enabled) async {
    try {
      await _remote.enableCollection(enabled);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
