import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class GetIntUseCase {
  GetIntUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<int>> call(String key) {
    return _repository.getInt(key);
  }
}
