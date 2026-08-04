import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required this.remoteDataSource});

  final PostRemoteDataSource remoteDataSource;

  @override
  Future<Result<void>> addPost(PostEntity post) async {
    try {
      await remoteDataSource.addPost(PostModel.fromEntity(post));

      return const Success(null);
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updatePost(PostEntity post) async {
    try {
      await remoteDataSource.updatePost(PostModel.fromEntity(post));

      return const Success(null);
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deletePost(String id) async {
    try {
      await remoteDataSource.deletePost(id);

      return const Success(null);
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<PostEntity>>> getPosts() async {
    try {
      final posts = await remoteDataSource.getPosts();

      return Success(posts);
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<PostEntity>> watchPosts() {
    return remoteDataSource.watchPosts();
  }

  @override
  Future<Result<PaginatedResult<PostEntity>>> getPaginatedPosts({
    Object? lastDocument,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getPaginatedPosts(
        lastDocument: lastDocument,
        limit: limit,
      );

      return Success(
        PaginatedResult<PostEntity>(
          items: result.items,
          lastDocument: result.lastDocument,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }
}
