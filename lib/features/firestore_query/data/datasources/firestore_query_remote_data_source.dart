import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/firestore_query_params.dart';
import '../../domain/entities/query_filter.dart';

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
  FirestoreQueryRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  Query<Map<String, dynamic>> _buildQuery(FirestoreQueryParams params) {
    Query<Map<String, dynamic>> query = _firestore.collection(
      params.collection,
    );

    query = _applyFilters(query, params);
    query = _applySorting(query, params);
    query = _applyPagination(query, params);

    return query;
  }

  Query<Map<String, dynamic>> _applyFilters(
    Query<Map<String, dynamic>> query,
    FirestoreQueryParams params,
  ) {
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

    return query;
  }

  Query<Map<String, dynamic>> _applySorting(
    Query<Map<String, dynamic>> query,
    FirestoreQueryParams params,
  ) {
    for (final order in params.orders) {
      query = query.orderBy(order.field, descending: order.descending);
    }

    return query;
  }

  Query<Map<String, dynamic>> _applyPagination(
    Query<Map<String, dynamic>> query,
    FirestoreQueryParams params,
  ) {
    if (params.limit != null) {
      query = params.limitToLast
          ? query.limitToLast(params.limit!)
          : query.limit(params.limit!);
    }

    if (params.startAfter != null) {
      query = query.startAfterDocument(params.startAfter!);
    }

    if (params.startAt != null) {
      query = query.startAtDocument(params.startAt!);
    }

    if (params.endAt != null) {
      query = query.endAtDocument(params.endAt!);
    }

    if (params.endBefore != null) {
      query = query.endBeforeDocument(params.endBefore!);
    }

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
