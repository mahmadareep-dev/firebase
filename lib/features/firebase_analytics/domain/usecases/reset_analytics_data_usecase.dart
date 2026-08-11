import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class ResetAnalyticsDataUseCase {
  ResetAnalyticsDataUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call() {
    return _repository.resetAnalyticsData();
  }
}