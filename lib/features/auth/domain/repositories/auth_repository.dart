import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Stream<AuthUserEntity?> get authStateChanges;

  AuthUserEntity? get currentUser;

  String? get currentUserEmail;

  bool get isEmailVerified;

  Future<AuthUserEntity> signInWithGoogle();

  Future<AuthUserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUserEntity> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> updatePassword(String newPassword);

  Future<void> reAuthenticate(String currentPassword);

  Future<void> reAuthenticateWithGoogle();

  Future<void> sendPhoneReauthOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  });

  Future<void> reAuthenticateWithPhoneOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> deleteAccount();

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> reloadCurrentUser();

  Future<void> resendVerificationEmail();

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  });

  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> completeProfile({required String name, String? photoUrl});
}
