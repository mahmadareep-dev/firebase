import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/query_filter.dart';
import '../../../firestore_query/domain/entities/query_order.dart';
import '../../domain/entities/firestore_pagination_params.dart';
import '../../domain/entities/pagination_result.dart';
import '../../domain/usecases/load_page_usecase.dart';

class FirestorePaginationBuilder<T> extends GetxController {
  FirestorePaginationBuilder({LoadPageUseCase? loadPageUseCase})
    : _loadPageUseCase = loadPageUseCase ?? Get.find<LoadPageUseCase>();

  final LoadPageUseCase _loadPageUseCase;

  /// Builder Configuration
  String? _collection;

  final List<QueryFilter> _filters = [];

  final List<QueryOrder> _orders = [];

  int _pageSize = 20;

  T Function(DocumentSnapshot<Map<String, dynamic>> document)? _fromFirestore;

  /// Pagination State
  final RxList<T> items = <T>[].obs;

  final RxBool isLoading = false.obs;

  final RxBool isLoadingMore = false.obs;

  final RxBool hasMore = true.obs;

  final RxString errorMessage = ''.obs;

  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;

  /// Builder API
  FirestorePaginationBuilder<T> collection(String path) {
    _collection = path;
    return this;
  }

  FirestorePaginationBuilder<T> pageSize(int size) {
    _pageSize = size;
    return this;
  }

  FirestorePaginationBuilder<T> fromFirestore(
    T Function(DocumentSnapshot<Map<String, dynamic>>) mapper,
  ) {
    _fromFirestore = mapper;
    return this;
  }

  FirestorePaginationBuilder<T> whereEqualTo(String field, dynamic value) {
    _filters.add(
      QueryFilter(field: field, operator: QueryOperator.equalTo, value: value),
    );

    return this;
  }

  FirestorePaginationBuilder<T> orderBy(
    String field, {
    bool descending = false,
  }) {
    _orders.add(QueryOrder(field: field, descending: descending));

    return this;
  }

  /// Load
  Future<Result<PaginationResult<T>>> load() async {
    if (_collection == null) {
      throw Exception('Collection not specified.');
    }

    if (_fromFirestore == null) {
      throw Exception('fromFirestore() not specified.');
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _loadPageUseCase.call<T>(
        params: FirestorePaginationParams(
          collection: _collection!,
          filters: _filters,
          orders: _orders,
          pageSize: _pageSize,
          lastDocument: _lastDocument,
        ),
        fromFirestore: _fromFirestore!,
      );

      result.when(
        success: (page) {
          items.assignAll(page.items);

          _lastDocument = page.lastDocument;

          hasMore.value = page.hasMore;
        },
        failure: (failure) {
          errorMessage.value = failure.message;
        },
      );

      return result;
    } finally {
      isLoading.value = false;
    }
  }

  /// Load More
  Future<Result<PaginationResult<T>>> loadMore() async {
    if (!hasMore.value) {
      return Success(
        PaginationResult<T>(
          items: const [],
          hasMore: false,
          lastDocument: _lastDocument,
        ),
      );
    }

    isLoadingMore.value = true;

    try {
      final result = await _loadPageUseCase.call<T>(
        params: FirestorePaginationParams(
          collection: _collection!,
          filters: _filters,
          orders: _orders,
          pageSize: _pageSize,
          lastDocument: _lastDocument,
        ),
        fromFirestore: _fromFirestore!,
      );

      result.when(
        success: (page) {
          items.addAll(page.items);

          _lastDocument = page.lastDocument;

          hasMore.value = page.hasMore;
        },
        failure: (failure) {
          errorMessage.value = failure.message;
        },
      );

      return result;
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Refresh
  @override
  Future<void> refresh() async {
    _lastDocument = null;

    items.clear();

    hasMore.value = true;

    await load();
  }
}
