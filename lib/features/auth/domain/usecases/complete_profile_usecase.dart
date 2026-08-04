import '../repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository repository;

  CompleteProfileUseCase(this.repository);

  Future<void> call({required String name, String? photoUrl}) {
    return repository.completeProfile(name: name, photoUrl: photoUrl);
  }
}
