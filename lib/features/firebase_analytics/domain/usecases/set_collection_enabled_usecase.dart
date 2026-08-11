import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class SetCollectionEnabledUseCase {
  SetCollectionEnabledUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call(
      bool enabled,
      ) {
    return _repository.setAnalyticsCollectionEnabled(
      enabled,
    );
  }
}