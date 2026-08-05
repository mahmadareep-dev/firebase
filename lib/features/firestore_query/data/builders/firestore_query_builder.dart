import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/firestore_query_params.dart';
import '../../domain/entities/query_filter.dart';
import '../../domain/entities/query_order.dart';
import '../../domain/usecases/execute_query_usecase.dart';
import '../../domain/usecases/watch_query_usecase.dart';

class FirestoreQueryBuilder<T> {
  FirestoreQueryBuilder({
    ExecuteQueryUseCase? executeQueryUseCase,
    WatchQueryUseCase? watchQueryUseCase,
  }) : _executeQueryUseCase =
           executeQueryUseCase ?? Get.find<ExecuteQueryUseCase>(),
       _watchQueryUseCase = watchQueryUseCase ?? Get.find<WatchQueryUseCase>();

  final ExecuteQueryUseCase _executeQueryUseCase;
  final WatchQueryUseCase _watchQueryUseCase;

  String? _collection;

  final List<QueryFilter> _filters = [];

  final List<QueryOrder> _orders = [];

  int? _limit;

  DocumentSnapshot<Map<String, dynamic>>? _startAfter;

  DocumentSnapshot<Map<String, dynamic>>? _endBefore;

  /// Collection

  FirestoreQueryBuilder<T> collection(String collection) {
    _collection = collection;
    return this;
  }

  /// Filters

  FirestoreQueryBuilder<T> whereEqualTo(String field, dynamic value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.equalTo, value: value),
    );

    return this;
  }

  FirestoreQueryBuilder<T> whereNotEqualTo(String field, dynamic value) {
    _filters.add(
      QueryFilter(
        field: field,
        operator: QueryOperator.notEqualTo,
        value: value,
      ),
    );

    return this;
  }

  FirestoreQueryBuilder<T> whereGreaterThan(String field, dynamic value) {
    _filters.add(
      QueryFilter(
        field: field,
        operator: QueryOperator.greaterThan,
        value: value,
      ),
    );

    return this;
  }

  FirestoreQueryBuilder<T> whereLessThan(String field, dynamic value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.lessThan, value: value),
    );

    return this;
  }

  FirestoreQueryBuilder<T> whereIn(String field, List<dynamic> value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.whereIn, value: value),
    );

    return this;
  }

  FirestoreQueryBuilder<T> arrayContains(String field, dynamic value) {
    _filters.add(
      QueryFilter(
        field: field,
        operator: QueryOperator.arrayContains,
        value: value,
      ),
    );

    return this;
  }

  /// Order

  FirestoreQueryBuilder<T> orderBy(String field, {bool descending = false}) {
    _orders.add(QueryOrder(field: field, descending: descending));

    return this;
  }

  /// Limit

  FirestoreQueryBuilder<T> limit(int value) {
    _limit = value;
    return this;
  }

  /// Pagination

  FirestoreQueryBuilder<T> startAfter(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    _startAfter = document;
    return this;
  }

  FirestoreQueryBuilder<T> endBefore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    _endBefore = document;
    return this;
  }

  /// Params

  FirestoreQueryParams _params() {
    if (_collection == null || _collection!.isEmpty) {
      throw Exception('Collection name is required.');
    }

    return FirestoreQueryParams(
      collection: _collection!,
      filters: List.unmodifiable(_filters),
      orders: List.unmodifiable(_orders),
      limit: _limit,
      startAfter: _startAfter,
      endBefore: _endBefore,
    );
  }

  /// Execute

  Future<Result<List<T>>> get({
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _executeQueryUseCase.call<T>(
      params: _params(),
      fromFirestore: fromFirestore,
    );
  }

  /// Watch

  Stream<Result<List<T>>> snapshots({
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _watchQueryUseCase.call<T>(
      params: _params(),
      fromFirestore: fromFirestore,
    );
  }
}
