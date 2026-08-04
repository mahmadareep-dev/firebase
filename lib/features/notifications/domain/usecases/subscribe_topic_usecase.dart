import '../../../../core/errors/result.dart';
import '../repositories/notification_repository.dart';

class SubscribeTopicUseCase {
  SubscribeTopicUseCase(this._repository);

  final NotificationRepository _repository;

  Future<Result<void>> call(String topic) {
    return _repository.subscribeToTopic(topic);
  }
}
