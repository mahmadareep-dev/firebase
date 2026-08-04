import '../../../../core/errors/result.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class UpdatePostUseCase {
  const UpdatePostUseCase(this.repository);

  final PostRepository repository;

  Future<Result<void>> call(PostEntity post) {
    return repository.updatePost(post);
  }
}
