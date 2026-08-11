import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class SetUserIdUseCase {
  SetUserIdUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call(
      String userId,
      ) {
    return _repository.setUserId(userId);
  }
}