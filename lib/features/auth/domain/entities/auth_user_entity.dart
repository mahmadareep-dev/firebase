class AuthUserEntity {
  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final bool isEmailVerified;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  final List<String> providers;

  const AuthUserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.photoUrl,
    required this.isEmailVerified,
    this.creationTime,
    this.lastSignInTime,
    this.providers = const [],
  });

  bool get isPasswordUser => providers.contains('password');

  bool get isGoogleUser => providers.contains('google.com');

  bool get isPhoneUser => providers.contains('phone');
}
