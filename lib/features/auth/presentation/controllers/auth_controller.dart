import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../profile/domain/entities/user_entity.dart';
import '../../../profile/domain/usecases/ensure_user_profile_usecase.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/check_email_verification_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/resend_verification_email_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/sign_in_with_email_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_up_with_email_usecase.dart';

class AuthController extends GetxController {
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final CheckEmailVerificationUseCase checkEmailVerificationUseCase;
  final ResendVerificationEmailUseCase resendVerificationEmailUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final EnsureUserProfileUseCase ensureUserProfileUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;

  AuthController({
    required this.signInWithEmailUseCase,
    required this.signInWithGoogleUseCase,
    required this.signUpWithEmailUseCase,
    required this.checkEmailVerificationUseCase,
    required this.resendVerificationEmailUseCase,
    required this.logoutUseCase,
    required this.authRepository,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
    required this.ensureUserProfileUseCase,
    required this.sendPasswordResetEmailUseCase,
  });

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final forgotPasswordEmailController = TextEditingController();

  final RxBool isResettingPassword = false.obs;
  final RxBool isCheckingVerification = false.obs;
  final RxBool isSendingVerification = false.obs;
  final RxBool isSignupLoading = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final RxBool isChangingPassword = false.obs;
  final RxBool isDeletingAccount = false.obs;
  final RxBool isLoggingOut = false.obs;

  AuthUserEntity? get currentUser => authRepository.currentUser;

  String get currentUserName => currentUser?.displayName ?? '';

  String get currentUserEmail => currentUser?.email ?? '';

  String get currentPhotoUrl => currentUser?.photoUrl ?? '';

  String get currentPhone => currentUser?.phoneNumber ?? '';

  String get currentUserId => currentUser?.uid ?? '';

  bool get isLoggedIn => currentUser != null;

  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    try {
      isLoading.value = true;

      await signInWithEmailUseCase(email: email, password: password);

      emailController.clear();
      passwordController.clear();
      // No navigation required.
      // Firebase userChanges() in main.dart handles the next screen.
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseAuthMessage(e));
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      await signInWithGoogleUseCase();
      await _ensureCurrentUserProfile();
      // Firebase userChanges() handles navigation.
    } on GoogleSignInException catch (e) {
      _showError(e.description ?? 'Google Sign-In failed');
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseAuthMessage(e));
    } catch (_) {
      _showError('Google Sign-In failed. Please try again.');
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<void> signupWithEmail() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    try {
      isSignupLoading.value = true;

      await signUpWithEmailUseCase(
        name: name,
        email: email,
        password: password,
      );

      await _ensureCurrentUserProfile(fallbackName: name);

      await logoutUseCase();

      signupNameController.clear();
      signupEmailController.clear();
      signupPasswordController.clear();

      Get.back();

      Get.snackbar(
        'Success',
        'Account created. Please verify your email, then login.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseAuthMessage(e));
    } catch (e) {
      _showError('Signup failed: $e');
    } finally {
      isSignupLoading.value = false;
    }
  }

  String _getFirebaseAuthMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Please enter a valid email';

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password';

      case 'user-disabled':
        return 'This account has been disabled';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later';

      case 'network-request-failed':
        return 'Please check your internet connection';

      default:
        return exception.message ?? 'Authentication failed';
    }
  }

  void _showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> checkEmailVerification() async {
    try {
      isCheckingVerification.value = true;

      final isVerified = await checkEmailVerificationUseCase();

      if (!isVerified) {
        _showError('Email is not verified yet. Please check your inbox.');
      }

      // No navigation required.
      // userChanges() will rebuild after reload.
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseAuthMessage(e));
    } catch (_) {
      _showError('Unable to check email verification.');
    } finally {
      isCheckingVerification.value = false;
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      isSendingVerification.value = true;

      await resendVerificationEmailUseCase();

      Get.snackbar(
        'Success',
        'Verification email sent again',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseAuthMessage(e));
    } catch (_) {
      _showError('Failed to send verification email');
    } finally {
      isSendingVerification.value = false;
    }
  }

  Future<void> sendPasswordResetEmail() async {
    final email = forgotPasswordEmailController.text.trim();

    if (email.isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showError('Please enter a valid email');
      return;
    }

    try {
      isResettingPassword.value = true;

      await sendPasswordResetEmailUseCase(email: email);

      forgotPasswordEmailController.clear();

      Get.back();

      Get.snackbar(
        'Success',
        'Password reset link has been sent to your email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email';
          break;

        case 'user-not-found':
          message = 'No account found with this email';
          break;

        case 'too-many-requests':
          message = 'Too many requests. Please try again later';
          break;

        default:
          message = e.message ?? 'Failed to send reset email';
      }

      _showError(message);
    } catch (_) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isResettingPassword.value = false;
    }
  }

  Future<void> logout() async {
    if (isLoggingOut.value) {
      return;
    }

    try {
      isLoggingOut.value = true;

      clearAccountForm();

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().clearProfile();
      }

      // AccountScreen was pushed above AuthSessionView.
      // Remove pushed screens before auth state changes the root.
      Get.until((route) => route.isFirst);

      await logoutUseCase();
    } catch (_) {
      _showError('Failed to logout');
    } finally {
      isLoggingOut.value = false;
    }
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      _showError('Please enter current and new password');
      return;
    }

    if (newPassword.length < 6) {
      _showError('New password must be at least 6 characters');
      return;
    }

    try {
      isChangingPassword.value = true;

      await changePasswordUseCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      clearAccountForm();

      Get.snackbar(
        'Success',
        'Password changed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Failed to change password');
    } catch (_) {
      _showError('Failed to change password');
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<void> deleteAccount() async {
    final password = currentPasswordController.text.trim();

    if (password.isEmpty) {
      _showError('Enter your current password first');
      return;
    }

    try {
      isDeletingAccount.value = true;

      await deleteAccountUseCase(currentPassword: password);

      clearAccountForm();

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().clearProfile();
      }

      Get.until((route) => route.isFirst);

      Get.snackbar(
        'Success',
        'Account deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _showError(_getFirebaseAuthMessage(e));
    } catch (_) {
      _showError('Failed to delete account');
    } finally {
      isDeletingAccount.value = false;
    }
  }

  void clearAccountForm() {
    currentPasswordController.clear();
    newPasswordController.clear();
  }

  Future<void> _ensureCurrentUserProfile({String? fallbackName}) async {
    final user = authRepository.currentUser;

    if (user == null) {
      throw Exception('Authenticated user not found');
    }

    await ensureUserProfileUseCase(
      UserEntity(
        uid: user.uid,
        name: user.displayName.trim().isNotEmpty
            ? user.displayName.trim()
            : fallbackName?.trim() ?? '',
        email: user.email,
        phone: user.phoneNumber,
        photoUrl: user.photoUrl,
        role: 'user',
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();

    currentPasswordController.dispose();
    newPasswordController.dispose();
    forgotPasswordEmailController.dispose();

    super.onClose();
  }
}
