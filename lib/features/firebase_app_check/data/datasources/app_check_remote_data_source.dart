import 'package:firebase_app_check/firebase_app_check.dart';

abstract interface class AppCheckRemoteDataSource {
  Future<void> activate();

  Future<String?> getToken();

  Future<String> getLimitedUseToken();

  Future<void> setTokenAutoRefreshEnabled(bool enabled);
}

class AppCheckRemoteDataSourceImpl implements AppCheckRemoteDataSource {
  const AppCheckRemoteDataSourceImpl();

  FirebaseAppCheck get _appCheck => FirebaseAppCheck.instance;

  @override
  Future<void> activate() {
    return _appCheck.activate();
  }

  @override
  Future<String?> getToken() {
    return _appCheck.getToken();
  }

  @override
  Future<String> getLimitedUseToken() {
    return _appCheck.getLimitedUseToken();
  }

  @override
  Future<void> setTokenAutoRefreshEnabled(bool enabled) {
    return _appCheck.setTokenAutoRefreshEnabled(enabled);
  }
}
