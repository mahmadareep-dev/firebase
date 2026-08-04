import '../../../../core/errors/result.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPaginatedPostsUseCase {
  const GetPaginatedPostsUseCase(this.repository);

  final PostRepository repository;

  Future<Result<PaginatedResult<PostEntity>>> call({
    Object? lastDocument,
    int limit = 10,
  }) {
    return repository.getPaginatedPosts(
      lastDocument: lastDocument,
      limit: limit,
    );
  }
}
