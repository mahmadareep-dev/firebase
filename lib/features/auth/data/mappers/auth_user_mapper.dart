import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_user_entity.dart';

class AuthUserMapper {
  const AuthUserMapper._();

  static AuthUserEntity fromFirebaseUser(User user) {
    return AuthUserEntity(
      uid: user.uid,
      displayName: user.displayName ?? '',
      email: user.email ?? '',
      phoneNumber: user.phoneNumber ?? '',
      photoUrl: user.photoURL ?? '',
      isEmailVerified: user.emailVerified,
      creationTime: user.metadata.creationTime,
      lastSignInTime: user.metadata.lastSignInTime,
      providers: user.providerData
          .map((provider) => provider.providerId)
          .toSet()
          .toList(),
    );
  }
}
