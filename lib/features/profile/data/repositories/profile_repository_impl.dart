import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<UserEntity>> getProfile(String uid) async {
    try {
      final user = await remoteDataSource.getProfile(uid);

      if (user == null) {
        return Error(
          FirestoreFailure(
            message: 'Profile not found.',
            code: 'profile-not-found',
          ),
        );
      }

      return Success(user);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(
          message: e.message ?? 'Failed to fetch profile.',
          code: e.code,
        ),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveProfile(UserEntity user) async {
    try {
      await remoteDataSource.saveProfile(UserModel.fromEntity(user));

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(
          message: e.message ?? 'Failed to save profile.',
          code: e.code,
        ),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateProfile(UserEntity user) async {
    try {
      await remoteDataSource.updateProfile(UserModel.fromEntity(user));

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(
          message: e.message ?? 'Failed to update profile.',
          code: e.code,
        ),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteProfile(String uid) async {
    try {
      await remoteDataSource.deleteProfile(uid);

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(
          message: e.message ?? 'Failed to delete profile.',
          code: e.code,
        ),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<bool>> profileExists(String uid) async {
    try {
      final exists = await remoteDataSource.profileExists(uid);

      return Success(exists);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(
          message: e.message ?? 'Failed to check profile.',
          code: e.code,
        ),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }
}
