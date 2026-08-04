import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class BasePaginationController<T> extends BaseController {
  /// Paginated items
  final RxList<T> items = <T>[].obs;

  /// Indicates whether next page is loading
  final RxBool isLoadingMore = false.obs;

  /// Whether more data is available
  final RxBool hasMore = true.obs;

  /// Scroll controller for infinite scrolling
  final ScrollController scrollController = ScrollController();

  /// Firestore pagination cursor
  Object? lastDocument;

  /// Convenience getters
  bool get isEmpty => items.isEmpty;

  bool get hasItems => items.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    if (isLoadingMore.value || !hasMore.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  /// Pull to refresh
  Future<void> refreshData() async {
    lastDocument = null;
    hasMore.value = true;
    items.clear();

    await loadFirstPage();
  }

  /// Load first page
  Future<void> loadFirstPage();

  /// Load next page
  Future<void> loadMore();
}
