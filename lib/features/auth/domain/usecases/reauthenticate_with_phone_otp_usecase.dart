import '../repositories/auth_repository.dart';

class ReauthenticateWithPhoneOtpUseCase {
  final AuthRepository repository;

  ReauthenticateWithPhoneOtpUseCase(this.repository);

  Future<void> call({required String verificationId, required String smsCode}) {
    return repository.reAuthenticateWithPhoneOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
