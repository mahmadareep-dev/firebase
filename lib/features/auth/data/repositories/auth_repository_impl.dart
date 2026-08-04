import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../mappers/auth_user_mapper.dart';
import '../mappers/firebase_auth_error_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<AuthUserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((user) {
      if (user == null) {
        return null;
      }

      return AuthUserMapper.fromFirebaseUser(user);
    });
  }

  @override
  AuthUserEntity? get currentUser {
    final user = remoteDataSource.currentUser;

    if (user == null) {
      return null;
    }

    return AuthUserMapper.fromFirebaseUser(user);
  }

  @override
  String? get currentUserEmail {
    return remoteDataSource.currentUserEmail;
  }

  @override
  bool get isEmailVerified {
    return remoteDataSource.isEmailVerified;
  }

  @override
  Future<void> logout() {
    return _handleFirebaseCall(() => remoteDataSource.logout());
  }

  @override
  Future<void> updatePassword(String newPassword) {
    return _handleFirebaseCall(
      () => remoteDataSource.updatePassword(newPassword),
    );
  }

  @override
  Future<void> reAuthenticate(String currentPassword) {
    return _handleFirebaseCall(
      () => remoteDataSource.reAuthenticate(currentPassword),
    );
  }

  @override
  Future<void> deleteAccount() {
    return _handleFirebaseCall(() => remoteDataSource.deleteAccount());
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _handleFirebaseCall(
      () => remoteDataSource.sendPasswordResetEmail(email: email),
    );
  }

  @override
  Future<void> reloadCurrentUser() {
    return _handleFirebaseCall(() => remoteDataSource.reloadCurrentUser());
  }

  @override
  Future<void> resendVerificationEmail() {
    return _handleFirebaseCall(
      () => remoteDataSource.resendVerificationEmail(),
    );
  }

  @override
  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  }) {
    return remoteDataSource.sendPhoneOtp(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationFailed: onVerificationFailed,
      onAutoVerified: onAutoVerified,
    );
  }

  @override
  Future<AuthUserEntity> signInWithGoogle() {
    return _handleFirebaseCall(() async {
      final credential = await remoteDataSource.signInWithGoogle();
      final user = credential.user;

      if (user == null) {
        throw const AppException(message: 'Google authentication failed');
      }

      return AuthUserMapper.fromFirebaseUser(user);
    });
  }

  @override
  Future<AuthUserEntity> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _handleFirebaseCall(() async {
      final credential = await remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AppException(message: 'Authentication failed');
      }

      return AuthUserMapper.fromFirebaseUser(user);
    });
  }

  @override
  Future<AuthUserEntity> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) {
    return _handleFirebaseCall(() async {
      final credential = await remoteDataSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw const AppException(message: 'Account creation failed');
      }

      return AuthUserMapper.fromFirebaseUser(user);
    });
  }

  @override
  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) {
    return _handleFirebaseCall(
      () => remoteDataSource.verifyPhoneOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      ),
    );
  }

  @override
  Future<void> completeProfile({required String name, String? photoUrl}) {
    return _handleFirebaseCall(
      () => remoteDataSource.completeProfile(name: name, photoUrl: photoUrl),
    );
  }

  Future<T> _handleFirebaseCall<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthErrorMapper.map(e);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }

      throw const AppException(
        message: 'Something went wrong. Please try again.',
      );
    }
  }
}
