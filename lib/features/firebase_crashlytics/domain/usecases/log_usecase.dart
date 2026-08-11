import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class LogUseCase {
  LogUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call(String message) {
    return _repository.log(message);
  }
}