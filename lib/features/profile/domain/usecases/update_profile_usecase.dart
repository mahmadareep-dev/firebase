import 'package:firebase/core/errors/result.dart';

import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Result<void>> call(UserEntity user) {
    return repository.updateProfile(user);
  }
}
