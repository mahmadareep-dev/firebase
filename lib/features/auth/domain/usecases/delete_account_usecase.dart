import '../../../../core/errors/app_exception.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository authRepository;

  DeleteAccountUseCase({
    required this.authRepository,
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
          message:
          'Phone verification is required before deleting your account.',
        );
      } else {
        throw const AppException(
          message: 'Unsupported authentication method.',
        );
      }
    }

    // Firebase Authentication account only.
    await authRepository.deleteAccount();
  }
}