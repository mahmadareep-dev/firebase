import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class ShowLocalNotificationUseCase {
  ShowLocalNotificationUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call(RemoteMessage message) {
    return _repository.showLocalNotification(message);
  }
}
