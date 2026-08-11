import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../../../firestore_query/domain/entities/query_filter.dart';
import '../../../firestore_query/domain/entities/query_order.dart';
import '../../domain/usecases/execute_collection_group_query_usecase.dart';
import '../../domain/usecases/watch_collection_group_query_usecase.dart';

class FirestoreCollectionGroupBuilder<T> {
  FirestoreCollectionGroupBuilder({
    ExecuteCollectionGroupQueryUseCase? executeUseCase,
    WatchCollectionGroupQueryUseCase? watchUseCase,
  }) : _executeUseCase =
           executeUseCase ?? Get.find<ExecuteCollectionGroupQueryUseCase>(),
       _watchUseCase =
           watchUseCase ?? Get.find<WatchCollectionGroupQueryUseCase>();

  final ExecuteCollectionGroupQueryUseCase _executeUseCase;
  final WatchCollectionGroupQueryUseCase _watchUseCase;

  String? _collection;

  /// Collection Group
  FirestoreCollectionGroupBuilder<T> collectionGroup(String collection) {
    _collection = collection;
    return this;
  }

  final List<QueryFilter> _filters = [];

  final List<QueryOrder> _orders = [];

  int? _limit;

  final bool _limitToLast = false;

  DocumentSnapshot<Map<String, dynamic>>? _startAfter;
  DocumentSnapshot<Map<String, dynamic>>? _startAt;
  DocumentSnapshot<Map<String, dynamic>>? _endBefore;
  DocumentSnapshot<Map<String, dynamic>>? _endAt;

  FirestoreQueryParams _params() {
    if (_collection == null || _collection!.isEmpty) {
      throw Exception('Collection group is required.');
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

  Future<Result<List<T>>> get({
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _executeUseCase.call(
      params: _params(),
      fromFirestore: fromFirestore,
    );
  }

  Stream<Result<List<T>>> snapshots({
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _watchUseCase.call(params: _params(), fromFirestore: fromFirestore);
  }
}
