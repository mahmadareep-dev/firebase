import '../repositories/auth_repository.dart';

class SendPhoneReauthOtpUseCase {
  final AuthRepository repository;

  SendPhoneReauthOtpUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  }) {
    return repository.sendPhoneReauthOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onAutoVerified: onAutoVerified,
    );
  }
}
