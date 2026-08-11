import '../../../../core/errors/result.dart';
import '../repositories/firebase_app_check_repository.dart';

class GetAppCheckTokenUseCase {
  GetAppCheckTokenUseCase(this._repository);

  final FirebaseAppCheckRepository _repository;

  Future<Result<String?>> call() {
    return _repository.getToken();
  }
}
