import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../features/firestore_query/domain/entities/query_filter.dart';
import '../../../../features/firestore_query/domain/entities/query_order.dart';

class FirestoreQueryEngine {
  const FirestoreQueryEngine(this._firestore);

  final FirebaseFirestore _firestore;

  Query<Map<String, dynamic>> build({
    required String collection,
    List<QueryFilter> filters = const [],
    List<QueryOrder> orders = const [],
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    query = _applyFilters(query, filters);
    query = _applyOrders(query, orders);

    return query;
  }

  Query<Map<String, dynamic>> buildCollectionGroup({
    required String collection,
    List<QueryFilter> filters = const [],
    List<QueryOrder> orders = const [],
    int? limit,
    bool limitToLast = false,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    DocumentSnapshot<Map<String, dynamic>>? startAt,
    DocumentSnapshot<Map<String, dynamic>>? endBefore,
    DocumentSnapshot<Map<String, dynamic>>? endAt,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collectionGroup(collection);

    query = _applyFilters(query, filters);
    query = _applyOrders(query, orders);

    if (limit != null) {
      query = limitToLast ? query.limitToLast(limit) : query.limit(limit);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    if (startAt != null) {
      query = query.startAtDocument(startAt);
    }

    if (endBefore != null) {
      query = query.endBeforeDocument(endBefore);
    }

    if (endAt != null) {
      query = query.endAtDocument(endAt);
    }

    return query;
  }

  Query<Map<String, dynamic>> _applyFilters(
    Query<Map<String, dynamic>> query,
    List<QueryFilter> filters,
  ) {
    for (final filter in filters) {
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

  Query<Map<String, dynamic>> _applyOrders(
    Query<Map<String, dynamic>> query,
    List<QueryOrder> orders,
  ) {
    for (final order in orders) {
      query = query.orderBy(order.field, descending: order.descending);
    }

    return query;
  }
}
