import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/errors/result.dart';

abstract class NotificationRepository {
  Future<Result<void>> initialize();

  Future<Result<NotificationSettings>> requestPermission();

  Future<Result<String?>> getToken();

  Future<Result<void>> subscribeToTopic(String topic);

  Future<Result<void>> unsubscribeFromTopic(String topic);

  Future<Result<RemoteMessage?>> getInitialMessage();

  Future<Result<void>> showLocalNotification(RemoteMessage message);

  Stream<RemoteMessage> get foregroundMessages;

  Stream<RemoteMessage> get notificationOpened;

  Stream<String> get tokenRefresh;
}
