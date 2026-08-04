import '../../domain/entities/network_status_entity.dart';
import '../../domain/repositories/connectivity_repository.dart';
import '../datasources/connectivity_remote_data_source.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._remoteDataSource);

  final ConnectivityRemoteDataSource _remoteDataSource;

  @override
  Future<NetworkStatusEntity> checkConnection() {
    return _remoteDataSource.checkConnection();
  }

  @override
  Stream<NetworkStatusEntity> watchConnection() {
    return _remoteDataSource.watchConnection();
  }
}
