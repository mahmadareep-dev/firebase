import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/usecases/activate_usecase.dart';
import '../../domain/usecases/fetch_and_activate_usecase.dart';
import '../../domain/usecases/fetch_usecase.dart';
import '../../domain/usecases/get_bool_usecase.dart';
import '../../domain/usecases/get_double_usecase.dart';
import '../../domain/usecases/get_int_usecase.dart';
import '../../domain/usecases/get_string_usecase.dart';
import '../../domain/usecases/set_defaults_usecase.dart';
import '../../domain/usecases/set_settings_usecase.dart';

class FirebaseRemoteConfigBuilder {
  FirebaseRemoteConfigBuilder({
    FetchUseCase? fetchUseCase,
    ActivateUseCase? activateUseCase,
    FetchAndActivateUseCase? fetchAndActivateUseCase,
    GetStringUseCase? getStringUseCase,
    GetBoolUseCase? getBoolUseCase,
    GetIntUseCase? getIntUseCase,
    GetDoubleUseCase? getDoubleUseCase,
    SetDefaultsUseCase? setDefaultsUseCase,
    SetSettingsUseCase? setSettingsUseCase,
  }) : _fetchUseCase = fetchUseCase ?? Get.find<FetchUseCase>(),
       _activateUseCase = activateUseCase ?? Get.find<ActivateUseCase>(),
       _fetchAndActivateUseCase =
           fetchAndActivateUseCase ?? Get.find<FetchAndActivateUseCase>(),
       _getStringUseCase = getStringUseCase ?? Get.find<GetStringUseCase>(),
       _getBoolUseCase = getBoolUseCase ?? Get.find<GetBoolUseCase>(),
       _getIntUseCase = getIntUseCase ?? Get.find<GetIntUseCase>(),
       _getDoubleUseCase = getDoubleUseCase ?? Get.find<GetDoubleUseCase>(),
       _setDefaultsUseCase =
           setDefaultsUseCase ?? Get.find<SetDefaultsUseCase>(),
       _setSettingsUseCase =
           setSettingsUseCase ?? Get.find<SetSettingsUseCase>();

  final FetchUseCase _fetchUseCase;
  final ActivateUseCase _activateUseCase;
  final FetchAndActivateUseCase _fetchAndActivateUseCase;
  final GetStringUseCase _getStringUseCase;
  final GetBoolUseCase _getBoolUseCase;
  final GetIntUseCase _getIntUseCase;
  final GetDoubleUseCase _getDoubleUseCase;
  final SetDefaultsUseCase _setDefaultsUseCase;
  final SetSettingsUseCase _setSettingsUseCase;

  Future<Result<void>> fetch() {
    return _fetchUseCase();
  }

  Future<Result<void>> activate() {
    return _activateUseCase();
  }

  Future<Result<void>> fetchAndActivate() {
    return _fetchAndActivateUseCase();
  }

  Future<Result<String>> getString(String key) {
    return _getStringUseCase(key);
  }

  Future<Result<bool>> getBool(String key) {
    return _getBoolUseCase(key);
  }

  Future<Result<int>> getInt(String key) {
    return _getIntUseCase(key);
  }

  Future<Result<double>> getDouble(String key) {
    return _getDoubleUseCase(key);
  }

  Future<Result<void>> setDefaults(Map<String, dynamic> defaults) {
    return _setDefaultsUseCase(defaults);
  }

  Future<Result<void>> setSettings(RemoteConfigSettings settings) {
    return _setSettingsUseCase(settings);
  }
}
