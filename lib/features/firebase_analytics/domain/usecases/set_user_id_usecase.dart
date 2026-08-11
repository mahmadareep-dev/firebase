import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class SetUserIdUseCase {
  SetUserIdUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call(
      String? userId,
      ) {
    return _repository.setUserId(userId);
  }
}