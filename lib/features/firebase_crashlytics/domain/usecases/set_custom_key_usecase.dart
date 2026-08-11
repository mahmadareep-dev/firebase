import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class SetCustomKeyUseCase {
  SetCustomKeyUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call({required String key, required Object value}) {
    return _repository.setCustomKey(key: key, value: value);
  }
}
