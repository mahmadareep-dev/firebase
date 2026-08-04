import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_fcm_token_usecase.dart';
import '../../domain/usecases/get_initial_message_usecase.dart';
import '../../domain/usecases/initialize_notifications_usecase.dart';
import '../../domain/usecases/request_notification_permission_usecase.dart';
import '../../domain/usecases/show_local_notification_usecase.dart';

class NotificationController extends GetxController {
  NotificationController({
    required this._initializeNotificationUseCase,
    required this._requestPermissionUseCase,
    required this._getFcmTokenUseCase,
    required this._getInitialMessageUseCase,
    required this._showLocalNotificationUseCase,
    required this._repository,
  });

  final InitializeNotificationUseCase _initializeNotificationUseCase;
  final RequestNotificationPermissionUseCase _requestPermissionUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;
  final GetInitialMessageUseCase _getInitialMessageUseCase;
  final ShowLocalNotificationUseCase _showLocalNotificationUseCase;
  final NotificationRepository _repository;

  final RxString fcmToken = ''.obs;

  final RxBool isPermissionGranted = false.obs;

  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    if (kDebugMode) {
      print("Notification initialization started");
    }

    await _initializeNotificationUseCase();

    if (kDebugMode) {
      print("Notification service initialized");
    }

    await _requestPermission();

    await _loadFcmToken();

    _listenTokenRefresh();
    _listenForegroundMessages();
    _listenNotificationOpened();

    await _checkInitialMessage();

    if (kDebugMode) {
      print("Notification initialization completed");
    }
  }

  Future<void> _requestPermission() async {
    final result = await _requestPermissionUseCase();

    result.when(
      success: (settings) {
        isPermissionGranted.value =
            settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
      },
      failure: (_) {},
    );
  }

  Future<void> _loadFcmToken() async {
    final result = await _getFcmTokenUseCase();

    result.when(
      success: (token) {
        fcmToken.value = token ?? '';
        if (kDebugMode) {
          print("FCM TOKEN:");
        }
        if (kDebugMode) {
          print(token);
        }
      },
      failure: (failure) {
        if (kDebugMode) {
          print("FCM Error: ${failure.message}");
        }
      },
    );
  }

  void _listenTokenRefresh() {
    _tokenSubscription = _repository.tokenRefresh.listen((token) {
      fcmToken.value = token;
    });
  }

  void _listenForegroundMessages() {
    _foregroundSubscription = _repository.foregroundMessages.listen((
      message,
    ) async {
      await _showLocalNotificationUseCase(message);
    });
  }

  void _listenNotificationOpened() {
    _openedSubscription = _repository.notificationOpened.listen((message) {
      _handleNotification(message);
    });
  }

  Future<void> _checkInitialMessage() async {
    final result = await _getInitialMessageUseCase();

    result.when(
      success: (message) {
        if (message != null) {
          _handleNotification(message);
        }
      },
      failure: (_) {},
    );
  }

  void _handleNotification(RemoteMessage message) {
    // Navigation will be implemented later.
  }

  @override
  void onClose() {
    _tokenSubscription?.cancel();
    _foregroundSubscription?.cancel();
    _openedSubscription?.cancel();
    super.onClose();
  }
}
