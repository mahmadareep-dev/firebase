import 'dart:async';

import 'package:get/get.dart';

import '../../../profile/domain/usecases/get_user_profile_usecase.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/observe_auth_state_usecase.dart';
import '../../domain/usecases/reload_current_user_usecase.dart';
import '../enum/auth_session_status.dart';

class AuthSessionController extends GetxController {
  final ObserveAuthStateUseCase observeAuthStateUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;
  final ReloadCurrentUserUseCase reloadCurrentUserUseCase;
  final AuthRepository authRepository;

  AuthSessionController({
    required this.observeAuthStateUseCase,
    required this.getUserProfileUseCase,
    required this.reloadCurrentUserUseCase,
    required this.authRepository,
  });

  final Rx<AuthSessionStatus> status = AuthSessionStatus.loading.obs;

  StreamSubscription<AuthUserEntity?>? _authSubscription;

  @override
  void onInit() {
    super.onInit();
    _observeAuthState();
  }

  void _observeAuthState() {
    _authSubscription = observeAuthStateUseCase().listen(
      _handleAuthState,
      onError: (_) {
        status.value = AuthSessionStatus.unauthenticated;
      },
    );
  }

  Future<void> _handleAuthState(AuthUserEntity? user) async {
    if (user == null) {
      status.value = AuthSessionStatus.unauthenticated;
      return;
    }

    status.value = AuthSessionStatus.loading;

    /// Email/password users must verify their email first.
    if (user.email.isNotEmpty && !user.isEmailVerified) {
      status.value = AuthSessionStatus.emailUnverified;
      return;
    }

    try {
      final profileResult = await getUserProfileUseCase(user.uid);

      profileResult.when(
        success: (_) {
          status.value = AuthSessionStatus.authenticated;
        },
        failure: (failure) {
          if (failure.code == 'profile-not-found') {
            status.value = AuthSessionStatus.profileIncomplete;
            return;
          }

          status.value = AuthSessionStatus.profileIncomplete;
        },
      );
    } catch (_) {
      status.value = AuthSessionStatus.error;
    }
  }

  Future<void> refreshSession() async {
    status.value = AuthSessionStatus.loading;

    try {
      await reloadCurrentUserUseCase();

      final user = authRepository.currentUser;

      if (user == null) {
        status.value = AuthSessionStatus.unauthenticated;
        return;
      }

      await _handleAuthState(user);
    } catch (_) {
      final user = authRepository.currentUser;

      if (user == null) {
        status.value = AuthSessionStatus.unauthenticated;
      } else {
        status.value = AuthSessionStatus.error;
      }
    }
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
