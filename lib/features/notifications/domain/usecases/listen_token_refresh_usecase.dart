import '../repositories/notification_repository.dart';

class ListenTokenRefreshUseCase {
  ListenTokenRefreshUseCase(this._repository);

  final NotificationRepository _repository;

  Stream<String> call() {
    return _repository.tokenRefresh;
  }
}
