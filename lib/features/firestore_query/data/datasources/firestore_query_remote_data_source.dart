import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/engine/firestore_cursor_engine.dart';
import '../../../../core/firestore/engine/firestore_query_engine.dart';
import '../../domain/entities/firestore_query_params.dart';

abstract interface class FirestoreQueryRemoteDataSource {
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

class FirestoreQueryRemoteDataSourceImpl
    implements FirestoreQueryRemoteDataSource {

  final FirestoreQueryEngine _queryEngine;
  final FirestoreCursorEngine _cursorEngine;

  FirestoreQueryRemoteDataSourceImpl(FirebaseFirestore firestore,)
      : _queryEngine = FirestoreQueryEngine(firestore),
        _cursorEngine = const FirestoreCursorEngine();

  Query<Map<String, dynamic>> _buildQuery(FirestoreQueryParams params,) {
    var query = _queryEngine.build(
      collection: params.collection,
      filters: params.filters,
      orders: params.orders,
    );

    query = _cursorEngine.apply(
      query,
      params,
    );

    return query;
  }
  @override
  Future<List<T>> execute<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async {
    try {
      final snapshot = await _buildQuery(params).get();

      return snapshot.docs.map(fromFirestore).toList();
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  @override
  Stream<List<T>> watch<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async* {
    try {
      await for (final snapshot in _buildQuery(params).snapshots()) {
        yield snapshot.docs.map(fromFirestore).toList();
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }
}
