import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  final isConnected = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  Future<ConnectivityService> onInit() async {
    super.onInit();

    final result = await _connectivity.checkConnectivity();
    isConnected.value = !result.contains(ConnectivityResult.none);

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      isConnected.value = !result.contains(ConnectivityResult.none);
    });

    return this;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
