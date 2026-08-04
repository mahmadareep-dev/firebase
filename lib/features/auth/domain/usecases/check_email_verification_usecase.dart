import '../repositories/auth_repository.dart';

class CheckEmailVerificationUseCase {
  final AuthRepository repository;

  CheckEmailVerificationUseCase(this.repository);

  Future<bool> call() async {
    await repository.reloadCurrentUser();

    return repository.isEmailVerified;
  }
}
