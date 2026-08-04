import '../../../profile/domain/repositories/profile_repository.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  DeleteAccountUseCase({
    required this.authRepository,
    required this.profileRepository,
  });

  Future<void> call({required String currentPassword}) async {
    final user = authRepository.currentUser;

    if (user == null) {
      throw Exception('User not found');
    }

    final uid = user.uid;

    // Must happen before deleting Firestore data.
    await authRepository.reAuthenticate(currentPassword);

    // Delete application data while authentication is valid.
    await profileRepository.deleteProfile(uid);

    // Delete Firebase Authentication account last.
    await authRepository.deleteAccount();
  }
}
