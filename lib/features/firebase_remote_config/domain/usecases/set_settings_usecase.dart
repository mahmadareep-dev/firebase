import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../core/errors/result.dart';
import '../repositories/remote_config_repository.dart';

class SetSettingsUseCase {
  SetSettingsUseCase(this._repository);

  final RemoteConfigRepository _repository;

  Future<Result<void>> call(RemoteConfigSettings settings) {
    return _repository.setSettings(settings);
  }
}
