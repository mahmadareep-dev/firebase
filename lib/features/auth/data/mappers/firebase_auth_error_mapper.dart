import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';

class FirebaseAuthErrorMapper {
  const FirebaseAuthErrorMapper._();

  static AppException map(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return const AppException(
          code: 'invalid-email',
          message: 'Please enter a valid email',
        );

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return const AppException(
          code: 'invalid-credential',
          message: 'Invalid email or password',
        );

      case 'email-already-in-use':
        return const AppException(
          code: 'email-already-in-use',
          message: 'This email is already registered',
        );

      case 'weak-password':
        return const AppException(
          code: 'weak-password',
          message: 'Password is too weak',
        );

      case 'user-disabled':
        return const AppException(
          code: 'user-disabled',
          message: 'This account has been disabled',
        );

      case 'too-many-requests':
        return const AppException(
          code: 'too-many-requests',
          message: 'Too many attempts. Please try again later',
        );

      case 'invalid-verification-code':
        return const AppException(
          code: 'invalid-verification-code',
          message: 'Invalid OTP',
        );

      case 'session-expired':
        return const AppException(
          code: 'session-expired',
          message: 'OTP expired. Please request a new OTP',
        );

      case 'requires-recent-login':
        return const AppException(
          code: 'requires-recent-login',
          message: 'Please login again before performing this action',
        );

      case 'network-request-failed':
        return const AppException(
          code: 'network-request-failed',
          message: 'Please check your internet connection',
        );

      default:
        return AppException(
          code: exception.code,
          message: exception.message ?? 'Authentication failed',
        );
    }
  }
}
