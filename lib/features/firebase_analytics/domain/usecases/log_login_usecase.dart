import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class LogLoginUseCase {
  LogLoginUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call({
    String? method,
  }) {
    return _repository.logLogin(
      method: method,
    );
  }
}