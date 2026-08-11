import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../../../firestore_query/domain/entities/query_filter.dart';
import '../../../firestore_query/domain/entities/query_order.dart';
import '../../domain/entities/firestore_listener.dart';
import '../../domain/usecases/listen_query_usecase.dart';

class FirestoreListenerBuilder<T> {
  FirestoreListenerBuilder({ListenQueryUseCase? listenQueryUseCase})
    : _listenQueryUseCase =
          listenQueryUseCase ?? Get.find<ListenQueryUseCase>();

  final ListenQueryUseCase _listenQueryUseCase;

  String? _collection;

  final List<QueryFilter> _filters = [];

  final List<QueryOrder> _orders = [];

  int? _limit;

  bool _limitToLast = false;

  DocumentSnapshot<Map<String, dynamic>>? _startAfter;
  DocumentSnapshot<Map<String, dynamic>>? _startAt;
  DocumentSnapshot<Map<String, dynamic>>? _endBefore;
  DocumentSnapshot<Map<String, dynamic>>? _endAt;

  FirestoreListenerBuilder<T> collection(String value) {
    _collection = value;
    return this;
  }

  FirestoreListenerBuilder<T> whereEqualTo(String field, dynamic value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.equalTo, value: value),
    );

    return this;
  }

  FirestoreListenerBuilder<T> whereNotEqualTo(String field, dynamic value) {
    _filters.add(
      QueryFilter(
        field: field,
        operator: QueryOperator.notEqualTo,
        value: value,
      ),
    );

    return this;
  }

  FirestoreListenerBuilder<T> whereGreaterThan(String field, dynamic value) {
    _filters.add(
      QueryFilter(
        field: field,
        operator: QueryOperator.greaterThan,
        value: value,
      ),
    );

    return this;
  }

  FirestoreListenerBuilder<T> whereLessThan(String field, dynamic value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.lessThan, value: value),
    );

    return this;
  }

  FirestoreListenerBuilder<T> whereIn(String field, List<dynamic> value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.whereIn, value: value),
    );

    return this;
  }

  FirestoreListenerBuilder<T> orderBy(String field, {bool descending = false}) {
    _orders.add(QueryOrder(field: field, descending: descending));

    return this;
  }

  FirestoreListenerBuilder<T> limit(int value) {
    _limit = value;
    return this;
  }

  FirestoreListenerBuilder<T> limitToLast(int value) {
    _limit = value;
    _limitToLast = true;
    return this;
  }

  FirestoreListenerBuilder<T> startAfter(
    DocumentSnapshot<Map<String, dynamic>> value,
  ) {
    _startAfter = value;
    return this;
  }

  FirestoreListenerBuilder<T> startAt(
    DocumentSnapshot<Map<String, dynamic>> value,
  ) {
    _startAt = value;
    return this;
  }

  FirestoreListenerBuilder<T> endBefore(
    DocumentSnapshot<Map<String, dynamic>> value,
  ) {
    _endBefore = value;
    return this;
  }

  FirestoreListenerBuilder<T> endAt(
    DocumentSnapshot<Map<String, dynamic>> value,
  ) {
    _endAt = value;
    return this;
  }

  FirestoreQueryParams _params() {
    if (_collection == null || _collection!.isEmpty) {
      throw Exception('Collection name is required.');
    }

    return FirestoreQueryParams(
      collection: _collection!,
      filters: List.unmodifiable(_filters),
      orders: List.unmodifiable(_orders),
      limit: _limit,
      limitToLast: _limitToLast,
      startAfter: _startAfter,
      startAt: _startAt,
      endBefore: _endBefore,
      endAt: _endAt,
    );
  }

  Stream<Result<List<T>>> listen({
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _listenQueryUseCase(params: _params(), fromFirestore: fromFirestore);
  }

  FirestoreListener<Result<List<T>>> subscribe({
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,

    required void Function(Result<List<T>> result) onData,

    Function(Object error, StackTrace stackTrace)? onError,

    void Function()? onDone,
  }) {
    final subscription = listen(
      fromFirestore: fromFirestore,
    ).listen(onData, onError: onError, onDone: onDone);

    return FirestoreListener<Result<List<T>>>(subscription);
  }
}
