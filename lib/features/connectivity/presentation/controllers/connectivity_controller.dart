import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../domain/entities/network_status_entity.dart';
import '../../domain/usecases/check_connection_usecase.dart';
import '../../domain/usecases/watch_connection_usecase.dart';

class ConnectivityController extends BaseController {
  ConnectivityController({
    required this.checkConnectionUseCase,
    required this.watchConnectionUseCase,
  });

  final CheckConnectionUseCase checkConnectionUseCase;
  final WatchConnectionUseCase watchConnectionUseCase;

  final Rx<NetworkStatusEntity> networkStatus = const NetworkStatusEntity(
    isConnected: true,
    connectionType: ConnectionType.none,
  ).obs;

  StreamSubscription<NetworkStatusEntity>? _subscription;

  bool get isConnected => networkStatus.value.isConnected;

  bool get isOffline => !isConnected;

  ConnectionType get connectionType => networkStatus.value.connectionType;

  @override
  void onInit() {
    super.onInit();

    initialize();
  }

  Future<void> initialize() async {
    await checkNow();

    _subscription = watchConnectionUseCase().listen((status) {
      networkStatus.value = status;
    });
  }

  Future<void> checkNow() async {
    networkStatus.value = await checkConnectionUseCase();
  }

  Future<void> retry() async {
    await checkNow();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
