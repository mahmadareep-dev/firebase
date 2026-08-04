import '../../domain/entities/network_status_entity.dart';

class NetworkStatusModel extends NetworkStatusEntity {
  const NetworkStatusModel({
    required super.isConnected,
    required super.connectionType,
  });

  factory NetworkStatusModel.fromConnectivityResult(
    ConnectionType connectionType,
  ) {
    return NetworkStatusModel(
      isConnected: connectionType != ConnectionType.none,
      connectionType: connectionType,
    );
  }
}
