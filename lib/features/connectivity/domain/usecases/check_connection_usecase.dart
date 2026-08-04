import '../entities/network_status_entity.dart';
import '../repositories/connectivity_repository.dart';

class CheckConnectionUseCase {
  final ConnectivityRepository repository;

  CheckConnectionUseCase(this.repository);

  Future<NetworkStatusEntity> call() {
    return repository.checkConnection();
  }
}
