import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/firebase_analytics_repository.dart';
import '../datasources/analytics_remote_data_source.dart';

class FirebaseAnalyticsRepositoryImpl implements FirebaseAnalyticsRepository {
  FirebaseAnalyticsRepositoryImpl(this._remote);

  final AnalyticsRemoteDataSource _remote;

  @override
  Future<Result<void>> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _remote.logEvent(name: name, parameters: parameters);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setUserId(String? userId) async {
    try {
      await _remote.setUserId(userId);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _remote.setUserProperty(name: name, value: value);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logLogin({String? method}) async {
    try {
      await _remote.logLogin(method: method);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logSignUp({required String method}) async {
    try {
      await _remote.logSignUp(method: method);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _remote.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> resetAnalyticsData() async {
    try {
      await _remote.resetAnalyticsData();
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setAnalyticsCollectionEnabled(bool enabled) async {
    try {
      await _remote.setAnalyticsCollectionEnabled(enabled);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
