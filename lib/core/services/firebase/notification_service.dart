import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../constants/firebase/notification_constants.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background Message: ${message.messageId}');
}

class NotificationService {
  NotificationService(this._firebaseMessaging, this._localNotificationsPlugin);

  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  late final AndroidNotificationChannel _channel;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await initializeLocalNotifications();
    await createAndroidChannel();
  }

  Future<void> initializeLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        NotificationConstants.notificationIcon,
      ),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification payload: ${response.payload}');
  }

  Future<void> createAndroidChannel() async {
    _channel = const AndroidNotificationChannel(
      NotificationConstants.channelId,
      NotificationConstants.channelName,
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    final androidImplementation = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(_channel);
  }

  Future<NotificationSettings> requestPermission() async {
    return _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<String?> getToken() {
    return _firebaseMessaging.getToken();
  }

  Stream<String> get onTokenRefresh {
    return _firebaseMessaging.onTokenRefresh;
  }

  Stream<RemoteMessage> get onForegroundMessage {
    return FirebaseMessaging.onMessage;
  }

  Stream<RemoteMessage> get onNotificationOpened {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  Future<RemoteMessage?> getInitialMessage() {
    return _firebaseMessaging.getInitialMessage();
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) return;

    await _localNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.toString(),
    );
  }

  Future<void> subscribeToTopic(String topic) {
    return _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) {
    return _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
