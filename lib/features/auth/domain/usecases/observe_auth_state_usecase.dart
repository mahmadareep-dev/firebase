import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class ObserveAuthStateUseCase {
  final AuthRepository repository;

  ObserveAuthStateUseCase(this.repository);

  Stream<AuthUserEntity?> call() {
    return repository.authStateChanges;
  }
}
