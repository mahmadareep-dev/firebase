import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class SetCustomKeysUseCase {
  SetCustomKeysUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call(
      Map<String, Object> keys,
      ) {
    return _repository.setCustomKeys(keys);
  }
}