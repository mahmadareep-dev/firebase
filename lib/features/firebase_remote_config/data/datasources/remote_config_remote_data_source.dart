import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract interface class RemoteConfigRemoteDataSource {
  Future<void> fetch();

  Future<void> activate();

  Future<void> fetchAndActivate();

  String getString(String key);

  bool getBool(String key);

  int getInt(String key);

  double getDouble(String key);

  Future<void> setDefaults(Map<String, dynamic> defaults);

  Future<void> setSettings(RemoteConfigSettings settings);
}

class RemoteConfigRemoteDataSourceImpl implements RemoteConfigRemoteDataSource {
  RemoteConfigRemoteDataSourceImpl(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  @override
  Future<void> fetch() async {
    await _remoteConfig.fetch();
  }

  @override
  Future<void> activate() async {
    await _remoteConfig.activate();
  }

  @override
  Future<void> fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }

  @override
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  @override
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  @override
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  @override
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  @override
  Future<void> setDefaults(Map<String, dynamic> defaults) async {
    await _remoteConfig.setDefaults(defaults);
  }

  @override
  Future<void> setSettings(RemoteConfigSettings settings) async {
    await _remoteConfig.setConfigSettings(settings);
  }
}
