import 'package:firebase/core/errors/result.dart';

import '../entities/user_entity.dart';

abstract class ProfileRepository {
  /// Get profile
  Future<Result<UserEntity>> getProfile(String uid);

  /// Create profile
  Future<Result<void>> saveProfile(UserEntity user);

  /// Update profile
  Future<Result<void>> updateProfile(UserEntity user);

  /// Delete profile
  Future<Result<void>> deleteProfile(String uid);

  /// Check if profile exists
  Future<Result<bool>> profileExists(String uid);
}
