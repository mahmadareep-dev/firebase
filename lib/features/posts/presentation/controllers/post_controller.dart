import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_crud_controller.dart';
import '../../../../core/services/file_picker/file_picker_service.dart';
import '../../../../core/services/snackbar/snackbar_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../file_storage/data/builders/firebase_storage_builder.dart';
import '../../../firestore_batch/data/builders/firestore_batch_builder.dart';
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

  ///Test

  Future<void> testBatchMixed() async {
    if (posts.length < 2) {
      showError('At least 2 posts are required for batch testing.');
      return;
    }

    final first = posts[0];
    final second = posts[1];

    debugPrint('========== FIRESTORE MIXED BATCH TEST ==========');
    debugPrint('UPDATE document: ${first.id}');
    debugPrint('SET + MERGE document: ${second.id}');

    final batch = FirestoreBatchBuilder();

    final result = await batch
        // Operation 1: UPDATE
        .update(
          collection: 'posts',
          documentId: first.id,
          data: {
            'mixedBatchUpdate': true,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        )
        // Operation 2: SET with MERGE
        .set(
          collection: 'posts',
          documentId: second.id,
          data: {
            'mixedBatchSet': true,
            'mixedBatchMessage': 'Mixed batch SET successful',
            'updatedAt': FieldValue.serverTimestamp(),
          },
          options: SetOptions(merge: true),
        )
        .commit();

    debugPrint('========== MIXED BATCH RESULT ==========');
    debugPrint('Result: $result');
    debugPrint('========================================');

    result.when(
      success: (_) {
        showSuccess('Mixed Firestore batch committed successfully.');
      },
      failure: (failure) {
        showError('Mixed batch failed: ${failure.message}');
      },
    );
  }

  Future<void> testBatchDelete() async {
    final testDocumentId =
        'batch_delete_test_${DateTime.now().millisecondsSinceEpoch}';

    debugPrint('========== FIRESTORE BATCH DELETE TEST ==========');
    debugPrint('Test Document ID: $testDocumentId');

    final authController = Get.find<AuthController>();

    // Check authentication
    if (!authController.isLoggedIn) {
      showError('User not logged in.');
      return;
    }

    final userId = authController.currentUserId;

    // ============================================================
    /// STEP 1: CREATE TEMPORARY DOCUMENT
    // ============================================================

    final createBatch = FirestoreBatchBuilder();

    final createResult = await createBatch
        .set(
          collection: 'posts',
          documentId: testDocumentId,
          data: {
            'userId': userId,
            'batchDeleteTest': true,
            'message': 'Temporary document for delete test',
            'createdAt': FieldValue.serverTimestamp(),
          },
        )
        .commit();

    debugPrint('========== CREATE RESULT ==========');
    debugPrint('Result: $createResult');
    debugPrint('===================================');

    // Stop if creation failed
    var createSucceeded = false;

    createResult.when(
      success: (_) {
        createSucceeded = true;
        debugPrint('Temporary document created successfully.');
      },
      failure: (failure) {
        debugPrint('Failed to create temporary document: ${failure.message}');

        showError('Delete test setup failed: ${failure.message}');
      },
    );

    if (!createSucceeded) {
      return;
    }

    // ============================================================
    /// STEP 2: DELETE TEMPORARY DOCUMENT
    // ============================================================

    final deleteBatch = FirestoreBatchBuilder();

    final deleteResult = await deleteBatch
        .delete(collection: 'posts', documentId: testDocumentId)
        .commit();

    debugPrint('========== DELETE BATCH RESULT ==========');
    debugPrint('Result: $deleteResult');
    debugPrint('=========================================');

    deleteResult.when(
      success: (_) {
        debugPrint('Temporary document deleted successfully.');

        showSuccess('Firestore batch DELETE committed successfully.');
      },
      failure: (failure) {
        debugPrint('Batch DELETE failed: ${failure.message}');

        showError('Batch DELETE failed: ${failure.message}');
      },
    );
  }

  Future<void> testBatchAtomicity() async {
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn) {
      showError('User not logged in.');
      return;
    }

    final userId = authController.currentUserId;

    final firstId =
        'batch_atomicity_first_${DateTime.now().millisecondsSinceEpoch}';

    final secondId =
        'batch_atomicity_second_${DateTime.now().millisecondsSinceEpoch}';

    debugPrint('========== FIRESTORE BATCH ATOMICITY TEST ==========');
    debugPrint('First temporary document: $firstId');
    debugPrint('Second temporary document: $secondId');

    // ============================================================
    // STEP 1: CREATE TWO TEMPORARY DOCUMENTS
    // ============================================================

    final setupBatch = FirestoreBatchBuilder();

    final setupResult = await setupBatch
        .set(
          collection: 'posts',
          documentId: firstId,
          data: {
            'userId': userId,
            'batchAtomicityTest': true,
            'name': 'Atomicity First',
          },
        )
        .set(
          collection: 'posts',
          documentId: secondId,
          data: {
            'userId': userId,
            'batchAtomicityTest': true,
            'name': 'Atomicity Second',
          },
        )
        .commit();

    var setupSucceeded = false;

    setupResult.when(
      success: (_) {
        setupSucceeded = true;
        debugPrint('Temporary documents created successfully.');
      },
      failure: (failure) {
        debugPrint('Setup failed: ${failure.message}');

        showError('Atomicity test setup failed: ${failure.message}');
      },
    );

    if (!setupSucceeded) {
      return;
    }

    // ============================================================
    // STEP 2: CREATE INTENTIONALLY FAILING BATCH
    // ============================================================

    final testBatch = FirestoreBatchBuilder();

    final result = await testBatch
        // Operation 1:
        // This should be VALID.
        .update(
          collection: 'posts',
          documentId: firstId,
          data: {
            'atomicityUpdate': true,
            'atomicityMessage': 'This should NOT be saved',
          },
        )
        // Operation 2:
        // This should FAIL because we attempt to change
        // the ownership of the document.
        .update(
          collection: 'posts',
          documentId: secondId,
          data: {'userId': 'unauthorized-user', 'atomicityFailure': true},
        )
        .commit();

    debugPrint('========== ATOMICITY RESULT ==========');
    debugPrint('Result: $result');
    debugPrint('======================================');

    var batchFailed = false;

    result.when(
      success: (_) {
        debugPrint('UNEXPECTED: Batch succeeded.');
      },
      failure: (failure) {
        batchFailed = true;

        debugPrint('Expected batch failure: ${failure.message}');
      },
    );

    // ============================================================
    // STEP 3: CLEANUP
    // ============================================================

    // final cleanupBatch = FirestoreBatchBuilder();
    //
    // final cleanupResult = await cleanupBatch
    //     .delete(collection: 'posts', documentId: firstId)
    //     .delete(collection: 'posts', documentId: secondId)
    //     .commit();

    // cleanupResult.when(
    //   success: (_) {
    //     debugPrint('Temporary atomicity documents deleted.');
    //   },
    //   failure: (failure) {
    //     debugPrint('Cleanup failed: ${failure.message}');
    //   },
    // );

    if (batchFailed) {
      showSuccess('Batch failed as expected. Atomicity can now be verified.');
    } else {
      showError('Atomicity test unexpectedly succeeded.');
    }
  }

  ///Test

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
    _watchSubscription = null;

    titleController.dispose();
    descriptionController.dispose();

    super.onClose();
  }

  void watchPosts() {
    _watchSubscription?.cancel();

    _watchSubscription = watchPostsUseCase().listen(
      (data) {
        posts.assignAll(data);
      },
      onError: (error) {
        errorMessage.value = error.toString();
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
