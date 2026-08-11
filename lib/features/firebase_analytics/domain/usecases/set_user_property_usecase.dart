import '../../../../core/errors/result.dart';
import '../repositories/firebase_analytics_repository.dart';

class SetUserPropertyUseCase {
  SetUserPropertyUseCase(this._repository);

  final FirebaseAnalyticsRepository _repository;

  Future<Result<void>> call({
    required String name,
    required String? value,
  }) {
    return _repository.setUserProperty(
      name: name,
      value: value,
    );
  }
}