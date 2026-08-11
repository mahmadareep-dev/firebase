import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class RecordErrorUseCase {
  RecordErrorUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call({
    required Object error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    return _repository.recordError(
      error: error,
      stackTrace: stackTrace,
      fatal: fatal,
    );
  }
}