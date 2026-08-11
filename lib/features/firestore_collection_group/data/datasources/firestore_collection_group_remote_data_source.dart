import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/engine/firestore_query_engine.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';

abstract interface class FirestoreCollectionGroupRemoteDataSource {
  Future<List<T>> execute<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  });

  Stream<List<T>> watch<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  });
}

class FirestoreCollectionGroupRemoteDataSourceImpl
    implements FirestoreCollectionGroupRemoteDataSource {
  FirestoreCollectionGroupRemoteDataSourceImpl(FirebaseFirestore firestore)
    : _queryEngine = FirestoreQueryEngine(firestore);

  final FirestoreQueryEngine _queryEngine;

  @override
  Future<List<T>> execute<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async {
    final query = _queryEngine.buildCollectionGroup(
      collection: params.collection,
      filters: params.filters,
      orders: params.orders,
      limit: params.limit,
      limitToLast: params.limitToLast,
      startAfter: params.startAfter,
      startAt: params.startAt,
      endBefore: params.endBefore,
      endAt: params.endAt,
    );

    final snapshot = await query.get();

    return snapshot.docs.map(fromFirestore).toList();
  }

  @override
  Stream<List<T>> watch<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async* {
    final query = _queryEngine.buildCollectionGroup(
      collection: params.collection,
      filters: params.filters,
      orders: params.orders,
      limit: params.limit,
      limitToLast: params.limitToLast,
      startAfter: params.startAfter,
      startAt: params.startAt,
      endBefore: params.endBefore,
      endAt: params.endAt,
    );

    await for (final snapshot in query.snapshots()) {
      yield snapshot.docs.map(fromFirestore).toList();
    }
  }
}
