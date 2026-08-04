import 'package:firebase_messaging/firebase_messaging.dart';

import '../repositories/notification_repository.dart';

class ListenForegroundMessagesUseCase {
  ListenForegroundMessagesUseCase(this._repository);

  final NotificationRepository _repository;

  Stream<RemoteMessage> call() {
    return _repository.foregroundMessages;
  }
}
