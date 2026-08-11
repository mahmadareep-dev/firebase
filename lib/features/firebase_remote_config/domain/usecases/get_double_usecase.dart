import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class GetDoubleUseCase {
  GetDoubleUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<double>> call(String key) {
    return _repository.getDouble(key);
  }
}
