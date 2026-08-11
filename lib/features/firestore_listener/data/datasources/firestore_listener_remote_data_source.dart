import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/engine/firestore_query_engine.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';

abstract interface class FirestoreListenerRemoteDataSource {
  Stream<List<T>> listen<T>({
    required FirestoreQueryParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  });
}

class FirestoreListenerRemoteDataSourceImpl
    implements FirestoreListenerRemoteDataSource {
  FirestoreListenerRemoteDataSourceImpl(
      FirebaseFirestore firestore,
      ) : _queryEngine = FirestoreQueryEngine(firestore);

  final FirestoreQueryEngine _queryEngine;

  @override
  Stream<List<T>> listen<T>({
    required FirestoreQueryParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  }) async* {
    final query = _queryEngine.build(
      collection: params.collection,
      filters: params.filters,
      orders: params.orders,
    );

    await for (final snapshot in query.snapshots()) {
      yield snapshot.docs.map(fromFirestore).toList();
    }
  }
}