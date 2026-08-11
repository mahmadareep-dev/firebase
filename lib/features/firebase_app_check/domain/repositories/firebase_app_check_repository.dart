import '../../../../core/errors/result.dart';

abstract interface class FirebaseAppCheckRepository {
  Future<Result<void>> activate();
  Future<Result<String?>> getToken();

  Future<Result<String>> getLimitedUseToken();

  Future<Result<void>> setTokenAutoRefreshEnabled(bool enabled,);
}