import 'package:firebase_messaging/firebase_messaging.dart';

import '../repositories/notification_repository.dart';

class ListenNotificationOpenedUseCase {
  ListenNotificationOpenedUseCase(this._repository);

  final NotificationRepository _repository;

  Stream<RemoteMessage> call() {
    return _repository.notificationOpened;
  }
}
