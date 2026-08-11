import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class LogScreenViewUseCase {
  LogScreenViewUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call({
    required String screenName,
    String? screenClass,
  }) {
    return _repository.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }
}