import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/engine/firestore_query_engine.dart';
import '../../domain/entities/firestore_pagination_params.dart';
import '../../domain/entities/pagination_result.dart';

abstract interface class FirestorePaginationRemoteDataSource {
  Future<PaginationResult<T>> load<T>({
    required FirestorePaginationParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  });
}

class FirestorePaginationRemoteDataSourceImpl
    implements FirestorePaginationRemoteDataSource {
  FirestorePaginationRemoteDataSourceImpl(FirebaseFirestore firestore,)
      : _queryEngine = FirestoreQueryEngine(firestore);

  final FirestoreQueryEngine _queryEngine;

  Query<Map<String, dynamic>> _buildQuery(FirestorePaginationParams params,) {
    Query<Map<String, dynamic>> query = _queryEngine.build(
      collection: params.collection,
      filters: params.filters,
      orders: params.orders,
    );

    if (params.lastDocument != null) {
      query = query.startAfterDocument(
        params.lastDocument!,
      );
    }

    query = query.limit(params.pageSize);

    return query;
  }

  @override
  Future<PaginationResult<T>> load<T>({
    required FirestorePaginationParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  }) async {
    final snapshot = await _buildQuery(params).get();

    return PaginationResult<T>(
      items: snapshot.docs.map(fromFirestore).toList(),
      hasMore: snapshot.docs.length == params.pageSize,
      lastDocument:
      snapshot.docs.isEmpty ? null : snapshot.docs.last,
    );
  }
}