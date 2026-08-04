import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class UnsubscribeTopicUseCase {
  UnsubscribeTopicUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call(String topic) {
    return _repository.unsubscribeFromTopic(topic);
  }
}
