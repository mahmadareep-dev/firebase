import '../repositories/auth_repository.dart';

class SendPhoneOtpUseCase {
  final AuthRepository repository;

  SendPhoneOtpUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  }) {
    return repository.sendPhoneOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onAutoVerified: onAutoVerified,
    );
  }
}
