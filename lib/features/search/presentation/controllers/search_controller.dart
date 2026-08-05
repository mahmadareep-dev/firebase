import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../domain/entities/search_params.dart';
import '../../domain/usecases/search_usecase.dart';

class SearchController<T> extends BaseController {
  SearchController({required this.searchUseCase});

  final SearchUseCase<T> searchUseCase;

  /// Search Input
  final TextEditingController textController = TextEditingController();

  /// Current Query
  final RxString query = ''.obs;

  /// Search Results
  final RxList<T> results = <T>[].obs;

  /// Whether more data exists
  final RxBool hasMore = false.obs;

  Timer? _debounce;

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }

  /// Search

  Future<void> search({String? keyword}) async {
    final value = (keyword ?? textController.text).trim();

    query.value = value;

    if (value.isEmpty) {
      clear();
      return;
    }

    startLoading();

    final response = await searchUseCase(SearchParams(query: value));

    response.when(
      success: (data) {
        results.assignAll(data.items);
        hasMore.value = data.hasMore;
        clearError();
      },
      failure: (failure) {
        results.clear();
        hasMore.value = false;
        setError(failure.message);
      },
    );

    stopLoading();
  }

  /// Debounce Search

  void onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => search(keyword: value),
    );
  }

  /// Refresh

  @override
  Future<void> refresh() async {
    await search();
  }

  /// Clear

  void clear() {
    query.value = '';
    results.clear();
    hasMore.value = false;
    textController.clear();
    clearError();
  }
}
