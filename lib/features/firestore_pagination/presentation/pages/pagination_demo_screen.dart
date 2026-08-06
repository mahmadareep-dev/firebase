import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../posts/data/models/post_model.dart';
import '../../data/builders/firestore_pagination_builder.dart';

class PaginationDemoScreen extends StatefulWidget {
  const PaginationDemoScreen({super.key});

  @override
  State<PaginationDemoScreen> createState() => _PaginationDemoScreenState();
}

class _PaginationDemoScreenState extends State<PaginationDemoScreen> {
  late final FirestorePaginationBuilder<PostModel> pagination;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    pagination = Get.put(
      FirestorePaginationBuilder<PostModel>()
        ..collection('posts')
        ..orderBy('createdAt', descending: true)
        ..pageSize(10)
        ..fromFirestore(PostModel.fromFirestore),
    );

    pagination.load();

    scrollController.addListener(_loadMoreListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMoreListener);

    scrollController.dispose();

    Get.delete<FirestorePaginationBuilder<PostModel>>();

    super.dispose();
  }

  void _loadMoreListener() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      pagination.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
