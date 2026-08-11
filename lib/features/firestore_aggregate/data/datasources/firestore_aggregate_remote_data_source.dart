import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/engine/firestore_query_engine.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';

abstract interface class FirestoreAggregateRemoteDataSource {
  Future<int> count({required FirestoreQueryParams params});
}

class FirestoreAggregateRemoteDataSourceImpl
    implements FirestoreAggregateRemoteDataSource {
  FirestoreAggregateRemoteDataSourceImpl(FirebaseFirestore firestore)
    : _queryEngine = FirestoreQueryEngine(firestore);

  final FirestoreQueryEngine _queryEngine;

  Query<Map<String, dynamic>> _query(FirestoreQueryParams params) {
    return _queryEngine.build(
      collection: params.collection,
      filters: params.filters,
      orders: params.orders,
    );
  }

  @override
  Future<int> count({required FirestoreQueryParams params}) async {
    final snapshot = await _query(params).count().get();
    return snapshot.count ?? 0;
  }
}
