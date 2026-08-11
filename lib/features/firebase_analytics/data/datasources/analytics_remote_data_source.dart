import 'package:firebase_analytics/firebase_analytics.dart';

abstract interface class AnalyticsRemoteDataSource {
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({required String name, required String? value});

  Future<void> logLogin({String? method});

  Future<void> logSignUp({required String method});

  Future<void> logScreenView({required String screenName, String? screenClass});

  Future<void> resetAnalyticsData();

  Future<void> setAnalyticsCollectionEnabled(bool enabled);
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  const AnalyticsRemoteDataSourceImpl();

  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId(String? userId) {
    return _analytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logLogin({String? method}) {
    if (method == null) {
      return _analytics.logLogin();
    }

    return _analytics.logLogin(loginMethod: method);
  }

  @override
  Future<void> logSignUp({required String method}) {
    return _analytics.logSignUp(signUpMethod: method);
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    if (screenClass == null) {
      return _analytics.logScreenView(screenName: screenName);
    }

    return _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  @override
  Future<void> resetAnalyticsData() {
    return _analytics.resetAnalyticsData();
  }

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) {
    return _analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
