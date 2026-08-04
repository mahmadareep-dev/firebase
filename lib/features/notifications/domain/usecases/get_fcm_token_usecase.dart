import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class GetFcmTokenUseCase {
  GetFcmTokenUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<String?>> call() {
    return _repository.getToken();
  }
}
