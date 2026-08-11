import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class GetBoolUseCase {
  GetBoolUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<bool>> call(String key) {
    return _repository.getBool(key);
  }
}
