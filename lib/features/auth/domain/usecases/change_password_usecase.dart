import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    await repository.reAuthenticate(currentPassword);
    await repository.updatePassword(newPassword);
  }
}
