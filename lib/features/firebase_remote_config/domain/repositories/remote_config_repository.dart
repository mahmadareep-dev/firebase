import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../core/errors/result.dart';

abstract interface class RemoteConfigRepository {
  Future<Result<void>> fetch();

  Future<Result<void>> activate();

  Future<Result<void>> fetchAndActivate();

  Future<Result<String>> getString(String key);

  Future<Result<bool>> getBool(String key);

  Future<Result<int>> getInt(String key);

  Future<Result<double>> getDouble(String key);

  Future<Result<void>> setDefaults(Map<String, dynamic> defaults);

  Future<Result<void>> setSettings(RemoteConfigSettings settings);
}
