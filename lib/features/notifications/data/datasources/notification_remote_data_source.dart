import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/services/firebase/notification_service.dart';

abstract class NotificationRemoteDataSource {
  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Future<void> initialize();

  Future<NotificationSettings> requestPermission();

  Future<String?> getToken();

  Stream<String> get onTokenRefresh;

  Stream<RemoteMessage> get onForegroundMessage;

  Stream<RemoteMessage> get onNotificationOpened;

  Future<RemoteMessage?> getInitialMessage();

  Future<void> showLocalNotification(RemoteMessage message);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<void> subscribeToTopic(String topic) {
    return _notificationService.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    return _notificationService.unsubscribeFromTopic(topic);
  }

  NotificationRemoteDataSourceImpl(this._notificationService);

  final NotificationService _notificationService;

  @override
  Future<void> initialize() {
    return _notificationService.initialize();
  }

  @override
  Future<NotificationSettings> requestPermission() {
    return _notificationService.requestPermission();
  }

  @override
  Future<String?> getToken() {
    return _notificationService.getToken();
  }

  @override
  Stream<String> get onTokenRefresh {
    return _notificationService.onTokenRefresh;
  }

  @override
  Stream<RemoteMessage> get onForegroundMessage {
    return _notificationService.onForegroundMessage;
  }

  @override
  Stream<RemoteMessage> get onNotificationOpened {
    return _notificationService.onNotificationOpened;
  }

  @override
  Future<RemoteMessage?> getInitialMessage() {
    return _notificationService.getInitialMessage();
  }

  @override
  Future<void> showLocalNotification(RemoteMessage message) {
    return _notificationService.showLocalNotification(message);
  }
}
