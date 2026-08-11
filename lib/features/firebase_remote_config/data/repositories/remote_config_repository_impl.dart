import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/remote_config_repository.dart';
import '../datasources/remote_config_remote_data_source.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  RemoteConfigRepositoryImpl(this._remote);

  final RemoteConfigRemoteDataSource _remote;

  @override
  Future<Result<void>> fetch() async {
    try {
      await _remote.fetch();
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> activate() async {
    try {
      await _remote.activate();
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> fetchAndActivate() async {
    try {
      await _remote.fetchAndActivate();
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> getString(String key) async {
    try {
      return Success(_remote.getString(key));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> getBool(String key) async {
    try {
      return Success(_remote.getBool(key));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<int>> getInt(String key) async {
    try {
      return Success(_remote.getInt(key));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<double>> getDouble(String key) async {
    try {
      return Success(_remote.getDouble(key));
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setDefaults(Map<String, dynamic> defaults) async {
    try {
      await _remote.setDefaults(defaults);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> setSettings(RemoteConfigSettings settings) async {
    try {
      await _remote.setSettings(settings);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
