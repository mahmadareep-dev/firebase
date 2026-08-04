import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/services/firebase/firestore_service.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<void> addPost(PostModel post);

  Future<void> updatePost(PostModel post);

  Future<void> deletePost(String id);

  Future<List<PostModel>> getPosts();

  Stream<List<PostModel>> watchPosts();

  Future<PaginatedResult<PostModel>> getPaginatedPosts({
    Object? lastDocument,
    int limit = 10,
  });
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  PostRemoteDataSourceImpl({required this.firestoreService});

  final FirestoreService firestoreService;

  CollectionReference<Map<String, dynamic>> get _posts =>
      firestoreService.collection('posts');

  @override
  Future<void> addPost(PostModel post) async {
    final doc = _posts.doc();

    final newPost = post.copyWith(id: doc.id);

    await doc.set(newPost.toFirestore());
  }

  @override
  Future<void> updatePost(PostModel post) async {
    await _posts.doc(post.id).update(post.toFirestore());
  }

  @override
  Future<void> deletePost(String id) async {
    await _posts.doc(id).delete();
  }

  @override
  Future<List<PostModel>> getPosts() async {
    final snapshot = await _posts.orderBy('createdAt', descending: true).get();

    return snapshot.docs.map(PostModel.fromFirestore).toList();
  }

  @override
  Stream<List<PostModel>> watchPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(PostModel.fromFirestore).toList());
  }

  @override
  Future<PaginatedResult<PostModel>> getPaginatedPosts({
    Object? lastDocument,
    int limit = 10,
  }) async {
    Query<Map<String, dynamic>> query = _posts
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(
        lastDocument as DocumentSnapshot<Map<String, dynamic>>,
      );
    }

    final snapshot = await query.get();

    final posts = snapshot.docs.map(PostModel.fromFirestore).toList();

    return PaginatedResult<PostModel>(
      items: posts,
      lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      hasMore: snapshot.docs.length == limit,
    );
  }
}
