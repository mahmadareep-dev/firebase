import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class EnableCollectionUseCase {
  EnableCollectionUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call(
      bool enabled,
      ) {
    return _repository.enableCollection(enabled);
  }
}