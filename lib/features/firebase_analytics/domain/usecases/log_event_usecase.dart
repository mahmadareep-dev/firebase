import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class LogEventUseCase {
  LogEventUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _repository.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}