import 'package:firebase/core/errors/result.dart';

import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Result<UserEntity>> call(String uid) {
    return repository.getProfile(uid);
  }
}
