import '../../../../core/errors/result.dart';
import '../repositories/firebase_app_check_repository.dart';

class SetTokenAutoRefreshUseCase {
  SetTokenAutoRefreshUseCase(this._repository);

  final FirebaseAppCheckRepository _repository;

  Future<Result<void>> call(
      bool enabled,
      ) {
    return _repository.setTokenAutoRefreshEnabled(
      enabled,
    );
  }
}