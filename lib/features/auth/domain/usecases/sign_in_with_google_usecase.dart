import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<AuthUserEntity> call() {
    return repository.signInWithGoogle();
  }
}
