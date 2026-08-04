import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class GetInitialMessageUseCase {
  GetInitialMessageUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<RemoteMessage?>> call() {
    return _repository.getInitialMessage();
  }
}
