import '../../../../core/errors/app_exception.dart';
import '../../../profile/domain/repositories/profile_repository.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  DeleteAccountUseCase({
    required this.authRepository,
    required this.profileRepository,
  });

  Future<void> call({
    String? currentPassword,
    bool alreadyReauthenticated = false,
  }) async {
    final user = authRepository.currentUser;

    if (user == null) {
      throw const AppException(
        message: 'User not found',
      );
    }

    final uid = user.uid;

    // Re-authenticate according to the user's authentication provider.
    if (!alreadyReauthenticated) {
      if (user.isPasswordUser) {
        if (currentPassword == null ||
            currentPassword
                .trim()
                .isEmpty) {
          throw const AppException(
            message: 'Enter your current password',
          );
        }

        await authRepository.reAuthenticate(
          currentPassword.trim(),
        );
      } else if (user.isGoogleUser) {
        await authRepository.reAuthenticateWithGoogle();
      } else if (user.isPhoneUser) {
        throw const AppException(
          message: 'Phone verification is required before deleting your account.',
        );
      } else {
        throw const AppException(
          message: 'Unsupported authentication method.',
        );
      }
    }

    // Delete Firestore profile first.
    final profileResult = await profileRepository.deleteProfile(uid);

    profileResult.when(
      success: (_) {},
      failure: (failure) {
        throw AppException(
          code: failure.code,
          message: failure.message,
        );
      },
    );

    // Delete Firebase Authentication account last.
    await authRepository.deleteAccount();
  }
}