import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class RequestNotificationPermissionUseCase {
  RequestNotificationPermissionUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<NotificationSettings>> call() {
    return _repository.requestPermission();
  }
}
