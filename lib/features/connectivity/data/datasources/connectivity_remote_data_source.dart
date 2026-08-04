import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/network_status_entity.dart';
import '../models/network_status_model.dart';

abstract class ConnectivityRemoteDataSource {
  Future<NetworkStatusModel> checkConnection();

  Stream<NetworkStatusModel> watchConnection();
}

class ConnectivityRemoteDataSourceImpl implements ConnectivityRemoteDataSource {
  ConnectivityRemoteDataSourceImpl(this._connectivity);

  final Connectivity _connectivity;

  ConnectionType _mapResult(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectionType.wifi;
    }

    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionType.mobile;
    }

    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectionType.ethernet;
    }

    if (results.contains(ConnectivityResult.vpn)) {
      return ConnectionType.vpn;
    }

    if (results.contains(ConnectivityResult.bluetooth)) {
      return ConnectionType.bluetooth;
    }

    if (results.contains(ConnectivityResult.other)) {
      return ConnectionType.other;
    }

    return ConnectionType.none;
  }

  @override
  Future<NetworkStatusModel> checkConnection() async {
    final results = await _connectivity.checkConnectivity();

    final type = _mapResult(results);

    return NetworkStatusModel.fromConnectivityResult(type);
  }

  @override
  Stream<NetworkStatusModel> watchConnection() {
    return _connectivity.onConnectivityChanged.map((results) {
      final type = _mapResult(results);

      return NetworkStatusModel.fromConnectivityResult(type);
    });
  }
}
