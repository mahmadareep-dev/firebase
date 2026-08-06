import 'package:cloud_firestore/cloud_firestore.dart';

import 'query_filter.dart';
import 'query_order.dart';

class FirestoreQueryParams {
  final String collection;

  final List<QueryFilter> filters;

  final List<QueryOrder> orders;

  final int? limit;

  final bool limitToLast;

  final DocumentSnapshot<Map<String, dynamic>>? startAfter;

  final DocumentSnapshot<Map<String, dynamic>>? startAt;

  final DocumentSnapshot<Map<String, dynamic>>? endBefore;

  final DocumentSnapshot<Map<String, dynamic>>? endAt;

  const FirestoreQueryParams({
    required this.collection,
    this.filters = const [],
    this.orders = const [],
    this.limit,
    this.limitToLast = false,
    this.startAfter,
    this.startAt,
    this.endBefore,
    this.endAt,
  });

  FirestoreQueryParams copyWith({
    String? collection,
    List<QueryFilter>? filters,
    List<QueryOrder>? orders,
    int? limit,
    bool? limitToLast,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    DocumentSnapshot<Map<String, dynamic>>? startAt,
    DocumentSnapshot<Map<String, dynamic>>? endBefore,
    DocumentSnapshot<Map<String, dynamic>>? endAt,
  }) {
    return FirestoreQueryParams(
      collection: collection ?? this.collection,
      filters: filters ?? this.filters,
      orders: orders ?? this.orders,
      limit: limit ?? this.limit,
      limitToLast: limitToLast ?? this.limitToLast,
      startAfter: startAfter ?? this.startAfter,
      startAt: startAt ?? this.startAt,
      endBefore: endBefore ?? this.endBefore,
      endAt: endAt ?? this.endAt,
    );
  }
}
