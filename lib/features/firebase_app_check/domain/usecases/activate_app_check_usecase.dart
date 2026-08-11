import '../../../../core/errors/result.dart';
import '../repositories/firebase_app_check_repository.dart';

class ActivateAppCheckUseCase {
  ActivateAppCheckUseCase(this._repository);

  final FirebaseAppCheckRepository _repository;

  Future<Result<void>> call() {
    return _repository.activate();
  }
}