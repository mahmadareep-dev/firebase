import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class GetStringUseCase {
  GetStringUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<String>> call(String key) {
    return _repository.getString(key);
  }
}
