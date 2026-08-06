import 'dart:io';

import 'package:firebase/core/base/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/services/file_picker/file_picker_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../file_storage/file_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileController extends BaseController {
  final GetUserProfileUseCase getUserProfileUseCase;
  final AuthRepository authRepository;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileController({
    required this.authRepository,
    required this.getUserProfileUseCase,
    required this.updateProfileUseCase,
  });


  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final selectedRole = 'user'.obs;
  final Rx<File?> selectedProfileImage = Rx<File?>(null);
  final isUpdating = false.obs;
  final isUploadingImage = false.obs;
  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final FirebaseStorageBuilder storage = FirebaseStorageBuilder();
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final firebaseUser = authRepository.currentUser;

    if (firebaseUser == null) {
      user.value = null;
      errorMessage.value = 'User not found';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getUserProfileUseCase(firebaseUser.uid);

      result.when(
        success: (profile) {
          user.value = profile;
          nameController.text = profile.name;
          emailController.text = profile.email;
          phoneController.text = profile.phone;
          selectedRole.value = profile.role;
        },
        failure: (failure) {
          user.value = null;
          errorMessage.value = failure.message;
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  Future<void> updateProfile() async {
    final firebaseUser = authRepository.currentUser;

    if (firebaseUser == null) {
      Get.snackbar(
        'Error',
        'User not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isUpdating.value = true;

    try {
      final updatedUser = UserEntity(
        uid: firebaseUser.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        photoUrl: user.value?.photoUrl ?? '',
        role: selectedRole.value,
        createdAt: user.value?.createdAt,
        updatedAt: DateTime.now(),
      );

      final result = await updateProfileUseCase(updatedUser);

      result.when(
        success: (_) async {
          await loadProfile();

          Get.back();

          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        failure: (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> uploadProfileImage() async {
    final firebaseUser = authRepository.currentUser;

    if (firebaseUser == null) {
      Get.snackbar(
        'Error',
        'User not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final File? file = await Get.find<FilePickerService>()
        .pickImageFromGallery();

    if (file == null) return;

    selectedProfileImage.value = file;
    isUploadingImage.value = true;

    try {
      final uploadResult = await storage.uploadFile(
        file: file,
        path: 'users/${firebaseUser.uid}/profile',
        fileName: 'profile.jpg',
      );

      await uploadResult.when(
        success: (uploadedFile) async {
          final updatedUser = UserEntity(
            uid: firebaseUser.uid,
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            phone: phoneController.text.trim(),
            photoUrl: uploadedFile.downloadUrl,
            role: selectedRole.value,
            createdAt: user.value?.createdAt,
            updatedAt: DateTime.now(),
          );

          final result = await updateProfileUseCase(updatedUser);

          result.when(
            success: (_) async {
              selectedProfileImage.value = null;

              await loadProfile();

              Get.snackbar(
                'Success',
                'Profile image updated successfully',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            failure: (failure) {
              Get.snackbar(
                'Error',
                failure.message,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          );
        },
        failure: (failure) async {
          selectedProfileImage.value = null;

          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  void clearProfile() {
    user.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
