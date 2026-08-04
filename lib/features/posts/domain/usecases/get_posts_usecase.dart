import '../../../../core/errors/result.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  const GetPostsUseCase(this.repository);

  final PostRepository repository;

  Future<Result<List<PostEntity>>> call() {
    return repository.getPosts();
  }
}
