import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/firebase_app_check_repository.dart';
import '../datasources/app_check_remote_data_source.dart';

class FirebaseAppCheckRepositoryImpl implements FirebaseAppCheckRepository {
  FirebaseAppCheckRepositoryImpl(this._remote);

  final AppCheckRemoteDataSource _remote;

  @override
  Future<Result<void>> activate() async {
    try {
      await _remote.activate();

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String?>> getToken({bool forceRefresh = false}) async {
    try {
      final token = await _remote.getToken();

      return Success(token);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> getLimitedUseToken() async {
    try {
      final token = await _remote.getLimitedUseToken();

      return Success(token);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setTokenAutoRefreshEnabled(bool enabled) async {
    try {
      await _remote.setTokenAutoRefreshEnabled(enabled);

      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
