import '../../../../core/errors/result.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Result<void>> addPost(PostEntity post);

  Future<Result<void>> updatePost(PostEntity post);

  Future<Result<void>> deletePost(String id);

  Future<Result<List<PostEntity>>> getPosts();

  Stream<List<PostEntity>> watchPosts();

  Future<Result<PaginatedResult<PostEntity>>> getPaginatedPosts({
    Object? lastDocument,
    int limit = 10,
  });
}
