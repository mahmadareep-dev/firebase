import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firestore_query/domain/entities/query_filter.dart';
import '../../domain/entities/firestore_pagination_params.dart';
import '../../domain/entities/pagination_result.dart';

abstract interface class FirestorePaginationRemoteDataSource {
  Future<PaginationResult<T>> load<T>({
    required FirestorePaginationParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  });
}

class FirestorePaginationRemoteDataSourceImpl
    implements FirestorePaginationRemoteDataSource {
  FirestorePaginationRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  Query<Map<String, dynamic>> _buildQuery(FirestorePaginationParams params) {
    Query<Map<String, dynamic>> query = _firestore.collection(
      params.collection,
    );

    /// Filters
    for (final filter in params.filters) {
      switch (filter.operator) {
        case QueryOperator.equalTo:
          query = query.where(filter.field, isEqualTo: filter.value);
          break;

        case QueryOperator.notEqualTo:
          query = query.where(filter.field, isNotEqualTo: filter.value);
          break;

        case QueryOperator.lessThan:
          query = query.where(filter.field, isLessThan: filter.value);
          break;

        case QueryOperator.lessThanOrEqualTo:
          query = query.where(filter.field, isLessThanOrEqualTo: filter.value);
          break;

        case QueryOperator.greaterThan:
          query = query.where(filter.field, isGreaterThan: filter.value);
          break;

        case QueryOperator.greaterThanOrEqualTo:
          query = query.where(
            filter.field,
            isGreaterThanOrEqualTo: filter.value,
          );
          break;

        case QueryOperator.whereIn:
          query = query.where(filter.field, whereIn: filter.value);
          break;

        case QueryOperator.whereNotIn:
          query = query.where(filter.field, whereNotIn: filter.value);
          break;

        case QueryOperator.arrayContains:
          query = query.where(filter.field, arrayContains: filter.value);
          break;

        case QueryOperator.arrayContainsAny:
          query = query.where(filter.field, arrayContainsAny: filter.value);
          break;

        case QueryOperator.isNull:
          query = query.where(filter.field, isNull: true);
          break;
      }
    }

    /// Order By
    for (final order in params.orders) {
      query = query.orderBy(order.field, descending: order.descending);
    }

    return query;
  }

  @override
  Future<PaginationResult<T>> load<T>({
    required FirestorePaginationParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async {
    Query<Map<String, dynamic>> query = _buildQuery(params);

    /// Next page
    if (params.lastDocument != null) {
      query = query.startAfterDocument(params.lastDocument!);
    }

    final snapshot = await query.limit(params.pageSize).get();

    return PaginationResult<T>(
      items: snapshot.docs.map(fromFirestore).toList(),
      hasMore: snapshot.docs.length == params.pageSize,
      lastDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
    );
  }
}
