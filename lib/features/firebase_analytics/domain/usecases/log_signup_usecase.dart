import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class LogSignUpUseCase {
  LogSignUpUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call({required String method}) {
    return _repository.logSignUp(method: method);
  }
}
