import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/search_empty_widget.dart';
import '../widgets/search_error_widget.dart';
import '../widgets/search_loading_widget.dart';

class SearchScreen<T> extends GetView<SearchController<T>> {
  const SearchScreen({
    super.key,
    required this.itemBuilder,
    this.hintText = 'Search...',
    this.title = 'Search',
  });

  /// Builds each search result item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Search hint.
  final String hintText;

  /// AppBar title.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchBar(
              controller: controller.textController,
              hintText: hintText,
              onChanged: controller.onChanged,
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const SearchLoadingWidget();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return SearchErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: controller.refresh,
                );
              }

              if (controller.results.isEmpty) {
                return const SearchEmptyWidget();
              }

              return ListView.builder(
                itemCount: controller.results.length,
                itemBuilder: (context, index) {
                  return itemBuilder(context, controller.results[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
