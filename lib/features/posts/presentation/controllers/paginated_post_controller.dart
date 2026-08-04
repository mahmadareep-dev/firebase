import 'package:firebase/core/base/base_pagination_controller.dart';
import 'package:firebase/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/add_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_paginated_posts_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';

class PaginatedPostController extends BasePaginationController<PostEntity> {
  PaginatedPostController({
    required this.getPaginatedPostsUseCase,
    required this.addPostUseCase,
    required this.updatePostUseCase,
    required this.deletePostUseCase,
  });

  final GetPaginatedPostsUseCase getPaginatedPostsUseCase;
  final AddPostUseCase addPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    loadFirstPage();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  @override
  Future<void> loadFirstPage() async {
    isLoading.value = true;
    errorMessage.value = '';

    lastDocument = null;
    hasMore.value = true;

    final result = await getPaginatedPostsUseCase(
      lastDocument: null,
      limit: 10,
    );

    result.when(
      success: (data) {
        items.assignAll(data.items);
        lastDocument = data.lastDocument;
        hasMore.value = data.hasMore;
      },
      failure: (failure) {
        errorMessage.value = failure.message;
      },
    );

    isLoading.value = false;
  }

  @override
  Future<void> loadMore() async {
    if (isLoadingMore.value) return;

    if (!hasMore.value) return;

    isLoadingMore.value = true;

    final result = await getPaginatedPostsUseCase(
      lastDocument: lastDocument,
      limit: 10,
    );

    result.when(
      success: (data) {
        items.addAll(data.items);

        lastDocument = data.lastDocument;

        hasMore.value = data.hasMore;
      },
      failure: (failure) {
        errorMessage.value = failure.message;
      },
    );

    isLoadingMore.value = false;
  }

  void fillFields(PostEntity post) {
    titleController.text = post.title;
    descriptionController.text = post.description;
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
  }

  Future<void> addPost() async {
    final post = PostEntity(
      id: '',
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      userId: '',
      userName: '',
      userPhoto: '',
      imageUrl: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await addPostUseCase(post);

    result.when(
      success: (_) async {
        clearFields();
        Get.back();
        await loadFirstPage();
        AppSnackbar.success('Post added');
      },
      failure: (failure) {
        AppSnackbar.error(failure.message);
      },
    );
  }

  Future<void> updatePost(PostEntity post) async {
    final result = await updatePostUseCase(
      post.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        updatedAt: DateTime.now(),
      ),
    );

    result.when(
      success: (_) async {
        clearFields();
        Get.back();
        await loadFirstPage();
        AppSnackbar.success('Post updated');
      },
      failure: (failure) {
        AppSnackbar.error(failure.message);
      },
    );
  }

  Future<void> deletePost(String id) async {
    final result = await deletePostUseCase(id);

    result.when(
      success: (_) async {
        await loadFirstPage();
        AppSnackbar.success('Post deleted');
      },
      failure: (failure) {
        AppSnackbar.error(failure.message);
      },
    );
  }
}
