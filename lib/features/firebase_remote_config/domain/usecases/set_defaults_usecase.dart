import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class SetDefaultsUseCase {
  SetDefaultsUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<void>> call(Map<String, dynamic> defaults) {
    return _repository.setDefaults(defaults);
  }
}
