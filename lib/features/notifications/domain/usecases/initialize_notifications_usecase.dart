import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class InitializeNotificationUseCase {
  InitializeNotificationUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call() {
    return _repository.initialize();
  }
}
