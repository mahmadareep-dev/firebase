import '../repositories/auth_repository.dart';

class ReloadCurrentUserUseCase {
  final AuthRepository repository;

  ReloadCurrentUserUseCase(this.repository);

  Future<void> call() {
    return repository.reloadCurrentUser();
  }
}
