import 'package:firebase/core/errors/result.dart';

import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class EnsureUserProfileUseCase {
  final ProfileRepository repository;

  EnsureUserProfileUseCase(this.repository);

  Future<Result<void>> call(UserEntity user) async {
    final result = await repository.profileExists(user.uid);

    return result.when(
      success: (exists) async {
        if (exists) {
          return const Success<void>(null);
        }

        return await repository.saveProfile(user);
      },
      failure: (failure) async {
        return Error<void>(failure);
      },
    );
  }
}
