import '../../../../core/errors/result.dart';

abstract interface class FirebaseAnalyticsRepository {
  Future<Result<void>> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<Result<void>> setUserId(String? userId);

  Future<Result<void>> setUserProperty({
    required String name,
    required String? value,
  });

  Future<Result<void>> logLogin({String? method});

  Future<Result<void>> logSignUp({required String method});

  Future<Result<void>> logScreenView({
    required String screenName,
    String? screenClass,
  });

  Future<Result<void>> resetAnalyticsData();

  Future<Result<void>> setAnalyticsCollectionEnabled(bool enabled);
}
