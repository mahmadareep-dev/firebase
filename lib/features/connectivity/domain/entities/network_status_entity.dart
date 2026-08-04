enum ConnectionType { wifi, mobile, ethernet, vpn, bluetooth, other, none }

class NetworkStatusEntity {
  final bool isConnected;
  final ConnectionType connectionType;

  const NetworkStatusEntity({
    required this.isConnected,
    required this.connectionType,
  });

  NetworkStatusEntity copyWith({
    bool? isConnected,
    ConnectionType? connectionType,
  }) {
    return NetworkStatusEntity(
      isConnected: isConnected ?? this.isConnected,
      connectionType: connectionType ?? this.connectionType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkStatusEntity &&
          runtimeType == other.runtimeType &&
          isConnected == other.isConnected &&
          connectionType == other.connectionType;

  @override
  int get hashCode => Object.hash(isConnected, connectionType);
}
