import '../entities/network_status_entity.dart';
import '../repositories/connectivity_repository.dart';

class WatchConnectionUseCase {
  final ConnectivityRepository repository;

  WatchConnectionUseCase(this.repository);

  Stream<NetworkStatusEntity> call() {
    return repository.watchConnection();
  }
}
