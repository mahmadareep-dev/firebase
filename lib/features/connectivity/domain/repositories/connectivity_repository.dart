import '../entities/network_status_entity.dart';

abstract class ConnectivityRepository {
  Future<NetworkStatusEntity> checkConnection();

  Stream<NetworkStatusEntity> watchConnection();
}
