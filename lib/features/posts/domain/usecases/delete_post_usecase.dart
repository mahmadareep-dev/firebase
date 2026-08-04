import '../../../../core/errors/result.dart';
import '../repositories/post_repository.dart';

class DeletePostUseCase {
  const DeletePostUseCase(this.repository);

  final PostRepository repository;

  Future<Result<void>> call(String id) {
    return repository.deletePost(id);
  }
}
