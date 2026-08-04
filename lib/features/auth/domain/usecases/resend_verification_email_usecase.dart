import '../repositories/auth_repository.dart';

class ResendVerificationEmailUseCase {
  final AuthRepository repository;

  ResendVerificationEmailUseCase(this.repository);

  Future<void> call() {
    return repository.resendVerificationEmail();
  }
}
