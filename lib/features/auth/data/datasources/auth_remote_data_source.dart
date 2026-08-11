import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;

  Future<UserCredential> signInWithGoogle();

  Future<void> logout();

  Future<void> updatePassword(String newPassword);

  Future<void> reAuthenticate(String currentPassword);

  Future reAuthenticateWithGoogle();

  Future sendPhoneReauthOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  });

  Future reAuthenticateWithPhoneOtp({
    required String verificationId,
    required String smsCode,
  });


  Future<void> deleteAccount();

  Future<void> reloadCurrentUser();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  });

  Future<void> resendVerificationEmail();

  String? get currentUserEmail;

  bool get isEmailVerified;

  User? get currentUser;

  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> completeProfile({required String name, String? photoUrl});

  Future<void> sendPasswordResetEmail({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  @override
  Future<void> reloadCurrentUser() async {
    await firebaseAuth.currentUser?.reload();
  }

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Stream<User?> get authStateChanges {
    return firebaseAuth.userChanges();
  }

  @override
  bool get isEmailVerified {
    return firebaseAuth.currentUser?.emailVerified ?? false;
  }

  @override
  User? get currentUser {
    return firebaseAuth.currentUser;
  }

  @override
  Future<void> resendVerificationEmail() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    await user.sendEmailVerification();
  }

  @override
  String? get currentUserEmail {
    return firebaseAuth.currentUser?.email;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName(name);

    await userCredential.user?.sendEmailVerification();

    await userCredential.user?.reload();

    return userCredential;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    await googleSignIn.initialize();

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> logout() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    await user.updatePassword(newPassword);
  }

  @override
  Future<void> reAuthenticate(String currentPassword) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    final email = user.email;

    if (email == null || email
        .trim()
        .isEmpty) {
      throw Exception('This account does not have an email address');
    }

    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: currentPassword,
    );
  }

  @override
  Future reAuthenticateWithGoogle() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    await googleSignIn.initialize();

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);
  }

  @override
  Future sendPhoneReauthOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
      throw Exception('No phone number linked to this account');
    }

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: user.phoneNumber!,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await user.reauthenticateWithCredential(credential);
          onAutoVerified();
        } catch (e) {
          onVerificationFailed(e.toString());
        }
      },

      verificationFailed: (FirebaseAuthException exception) {
        onVerificationFailed(
          exception.message ?? 'Phone verification failed',
        );
      },

      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future reAuthenticateWithPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await user.reauthenticateWithCredential(credential);
  }

  @override
  Future<void> deleteAccount() async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No user logged in');
    }

    await user.delete();
  }

  @override
  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onVerificationFailed,
    required void Function() onAutoVerified,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await firebaseAuth.signInWithCredential(credential);
        onAutoVerified();
      },

      verificationFailed: (FirebaseAuthException exception) {
        onVerificationFailed(exception.message ?? 'OTP verification failed');
      },

      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<void> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> completeProfile({required String name, String? photoUrl}) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User not found');
    }

    await user.updateDisplayName(name);

    if (photoUrl != null && photoUrl.trim().isNotEmpty) {
      await user.updatePhotoURL(photoUrl.trim());
    }

    await user.reload();
  }
}
