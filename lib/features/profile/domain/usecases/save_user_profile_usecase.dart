import 'package:firebase/core/errors/result.dart';

import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class SaveUserProfileUseCase {
  final ProfileRepository repository;

  SaveUserProfileUseCase(this.repository);

  Future<Result<void>> call(UserEntity user) {
    return repository.saveProfile(user);
  }
}