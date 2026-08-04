import '../repositories/auth_repository.dart';

class VerifyPhoneOtpUseCase {
  final AuthRepository repository;

  VerifyPhoneOtpUseCase(this.repository);

  Future<void> call({required String verificationId, required String smsCode}) {
    return repository.verifyPhoneOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
