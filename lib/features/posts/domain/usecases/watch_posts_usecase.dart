import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class WatchPostsUseCase {
  const WatchPostsUseCase(this.repository);

  final PostRepository repository;

  Stream<List<PostEntity>> call() {
    return repository.watchPosts();
  }
}
