import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        signInWithEmailUseCase: Get.find(),
        signInWithGoogleUseCase: Get.find(),
        signUpWithEmailUseCase: Get.find(),
        checkEmailVerificationUseCase: Get.find(),
        resendVerificationEmailUseCase: Get.find(),
        logoutUseCase: Get.find(),
        authRepository: Get.find(),
        changePasswordUseCase: Get.find(),
        deleteAccountUseCase: Get.find(),
        ensureUserProfileUseCase: Get.find(),
        sendPasswordResetEmailUseCase: Get.find(),
      ),
    );
  }
}
