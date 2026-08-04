import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../profile/domain/entities/user_entity.dart';
import '../../../profile/domain/usecases/save_user_profile_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import 'auth_session_controller.dart';

class CompleteProfileController extends GetxController {
  final CompleteProfileUseCase completeProfileUseCase;
  final AuthRepository authRepository;
  final SaveUserProfileUseCase saveUserProfileUseCase;

  CompleteProfileController({
    required this.completeProfileUseCase,
    required this.authRepository,
    required this.saveUserProfileUseCase,
  });

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final profileImageController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final Rxn<File> selectedImage = Rxn<File>();
  final RxBool isUploadingImage = false.obs;
  final RxBool isSavingProfile = false.obs;

  String get createdAt {
    return authRepository.currentUser?.creationTime?.toString() ??
        'Not available';
  }

  @override
  void onInit() {
    super.onInit();
    loadCurrentUserProfile();
  }

  void loadCurrentUserProfile() {
    final user = authRepository.currentUser;

    nameController.text = user?.displayName ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phoneNumber ?? '';
    profileImageController.text = user?.photoUrl ?? '';
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    profileImageController.clear();
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your name');
      return;
    }

    final authUser = authRepository.currentUser;

    if (authUser == null) {
      _showError('User not found');
      return;
    }

    try {
      isSavingProfile.value = true;
      String profileImageUrl = profileImageController.text.trim();

      if (selectedImage.value != null) {
        isUploadingImage.value = true;

        profileImageController.text = profileImageUrl;
      }

      /// Update Firebase Authentication basic profile.
      await completeProfileUseCase(name: name, photoUrl: profileImageUrl);

      /// Save the complete application profile in Firestore.
      final userEntity = UserEntity(
        uid: authUser.uid,
        name: name,
        email: authUser.email.isNotEmpty
            ? authUser.email
            : emailController.text.trim(),
        phone: authUser.phoneNumber.isNotEmpty
            ? authUser.phoneNumber
            : phoneController.text.trim(),
        photoUrl: profileImageUrl,
        role: "user",
      );

      await saveUserProfileUseCase(userEntity);

      if (Get.isRegistered<AuthSessionController>()) {
        await Get.find<AuthSessionController>().refreshSession();
      }

      /// Clear only after everything was successfully saved.
      clearFields();

      Get.snackbar(
        'Success',
        'Profile completed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      /// No manual navigation is required.
      /// AuthSessionController detects the Firestore profile
      /// and automatically changes the root screen to HomeScreen.
    } catch (e) {
      _showError('Failed to update profile');
    } finally {
      isSavingProfile.value = false;
      isUploadingImage.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  bool get hasAuthEmail {
    return authRepository.currentUser?.email.isNotEmpty ?? false;
  }

  bool get hasAuthPhone {
    return authRepository.currentUser?.phoneNumber.isNotEmpty ?? false;
  }

  Future<void> pickProfileImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (pickedFile == null) {
        return;
      }

      selectedImage.value = File(pickedFile.path);
    } catch (_) {
      _showError('Failed to select image');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    profileImageController.dispose();
    super.onClose();
  }
}
