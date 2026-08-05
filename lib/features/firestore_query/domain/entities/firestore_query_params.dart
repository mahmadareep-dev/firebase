import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/features/firestore_query/domain/entities/query_filter.dart';
import 'package:firebase/features/firestore_query/domain/entities/query_order.dart';

class FirestoreQueryParams {
  final String collection;

  final List<QueryFilter> filters;

  final List<QueryOrder> orders;

  final int? limit;

  final DocumentSnapshot<Map<String, dynamic>>? startAfter;

  final DocumentSnapshot<Map<String, dynamic>>? endBefore;

  const FirestoreQueryParams({
    required this.collection,
    this.filters = const [],
    this.orders = const [],
    this.limit,
    this.startAfter,
    this.endBefore,
  });

  FirestoreQueryParams copyWith({
    String? collection,
    List<QueryFilter>? filters,
    List<QueryOrder>? orders,
    int? limit,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    DocumentSnapshot<Map<String, dynamic>>? endBefore,
  }) {
    return FirestoreQueryParams(
      collection: collection ?? this.collection,
      filters: filters ?? this.filters,
      orders: orders ?? this.orders,
      limit: limit ?? this.limit,
      startAfter: startAfter ?? this.startAfter,
      endBefore: endBefore ?? this.endBefore,
    );
  }
}
