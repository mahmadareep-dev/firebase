import '../../../../core/errors/result.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class AddPostUseCase {
  const AddPostUseCase(this.repository);

  final PostRepository repository;

  Future<Result<void>> call(PostEntity post) {
    return repository.addPost(post);
  }
}
