import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_crud_controller.dart';
import '../../../../core/services/file_picker/file_picker_service.dart';
import '../../../../core/services/snackbar/snackbar_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../file_storage/data/builders/firebase_storage_builder.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/add_post_usecase.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/watch_posts_usecase.dart';

class PostController extends BaseCrudController {
  PostController({
    required this.addPostUseCase,
    required this.updatePostUseCase,
    required this.deletePostUseCase,
    required this.getPostsUseCase,
    required this.watchPostsUseCase,
  });

  final AddPostUseCase addPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final GetPostsUseCase getPostsUseCase;
  final WatchPostsUseCase watchPostsUseCase;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString imageUrl = ''.obs;
  final posts = <PostEntity>[].obs;

  final FirebaseStorageBuilder _storage = FirebaseStorageBuilder();
  final RxBool isUploadingImage = false.obs;

  StreamSubscription<List<PostEntity>>? _watchSubscription;

  @override
  void onInit() {
    super.onInit();
    watchPosts();
  }

  @override
  void onClose() {
    _watchSubscription?.cancel();

    titleController.dispose();
    descriptionController.dispose();

    super.onClose();
  }

  void watchPosts() {
    _watchSubscription?.cancel();

    _watchSubscription = watchPostsUseCase().listen(
      (data) {
        clearError();
        posts.assignAll(data);
      },
      onError: (error) {
        setError(error.toString());
      },
    );
  }

  Future<void> loadPosts() async {
    startLoading();

    try {
      final result = await getPostsUseCase();

      result.when(
        success: (data) {
          posts.assignAll(data);
        },
        failure: (failure) {
          setError(failure.message);
        },
      );
    } finally {
      stopLoading();
    }
  }

  bool validatePost() {
    if (titleController.text.trim().isEmpty) {
      showInfo('Title is required');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      showInfo('Description is required');
      return false;
    }

    return true;
  }

  Future<void> addPost() async {
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn) {
      SnackbarService.error('User not logged in');
      return;
    }

    if (!validatePost()) {
      return;
    }

    startSaving();

    try {
      final post = PostEntity(
        id: '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),

        userId: authController.currentUserId,
        userName: authController.currentUserName,
        userPhoto: authController.currentPhotoUrl,
        imageUrl: imageUrl.value,

        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await addPostUseCase(post);

      result.when(
        success: (_) {
          clearFields();
          Get.back();
          showSuccess('Post added successfully.');
        },
        failure: (failure) {
          showError(failure.message);
        },
      );
    } finally {
      stopSaving();
    }
  }

  Future<void> updatePost(PostEntity post) async {
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn) {
      SnackbarService.error('User not logged in');
      return;
    }

    if (!validatePost()) {
      return;
    }

    startSaving();

    try {
      if (post.userId != authController.currentUserId) {
        showError('You can only edit your own posts.');
        return;
      }
      final updatedPost = post.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        updatedAt: DateTime.now(),
      );

      final result = await updatePostUseCase(updatedPost);

      result.when(
        success: (_) {
          clearFields();
          Get.back();
          showSuccess('Post updated successfully.');
        },
        failure: (failure) {
          showError(failure.message);
        },
      );
    } finally {
      stopSaving();
    }
  }

  Future<void> deletePost(PostEntity post) async {
    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      SnackbarService.error('User not logged in');
      return;
    }

    startSaving();

    try {
      final result = await deletePostUseCase(post.id);

      result.when(
        success: (_) {
          showSuccess('Post deleted successfully.');
        },
        failure: (failure) {
          showError(failure.message);
        },
      );
    } finally {
      stopSaving();
    }
  }

  Future<void> pickPostImage() async {
    final File? file = await Get.find<FilePickerService>()
        .pickImageFromGallery();

    if (file == null) {
      return;
    }

    isUploadingImage.value = true;

    try {
      final uploadResult = await _storage.uploadImage(
        image: file,
        path: 'posts',
        fileName: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      uploadResult.when(
        success: (uploadedFile) {
          imageUrl.value = uploadedFile.downloadUrl;

          showSuccess('Image uploaded successfully.');
        },
        failure: (failure) {
          showError(failure.message);
        },
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  void fillFields(PostEntity post) {
    titleController.text = post.title;
    descriptionController.text = post.description;
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();

    imageUrl.value = '';
  }
}
