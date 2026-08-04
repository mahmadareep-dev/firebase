import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  Future<AuthUserEntity> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUpWithEmail(
      name: name,
      email: email,
      password: password,
    );
  }
}
