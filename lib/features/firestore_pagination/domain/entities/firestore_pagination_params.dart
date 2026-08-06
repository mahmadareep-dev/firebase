import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firestore_query/domain/entities/query_filter.dart';
import '../../../firestore_query/domain/entities/query_order.dart';

class FirestorePaginationParams {
  const FirestorePaginationParams({
    required this.collection,
    this.filters = const [],
    this.orders = const [],
    required this.pageSize,
    this.lastDocument,
  });

  final String collection;

  final List<QueryFilter> filters;

  final List<QueryOrder> orders;

  final int pageSize;

  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;

  FirestorePaginationParams copyWith({
    String? collection,
    List<QueryFilter>? filters,
    List<QueryOrder>? orders,
    int? pageSize,
    DocumentSnapshot<Map<String, dynamic>>? lastDocument,
  }) {
    return FirestorePaginationParams(
      collection: collection ?? this.collection,
      filters: filters ?? this.filters,
      orders: orders ?? this.orders,
      pageSize: pageSize ?? this.pageSize,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}
