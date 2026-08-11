import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class FetchAndActivateUseCase {
  FetchAndActivateUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<void>> call() {
    return _repository.fetchAndActivate();
  }
}
