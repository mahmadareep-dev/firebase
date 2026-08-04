import 'package:get/get.dart';

import '../../features/auth/presentation/pages/home_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/phone/complete_profile_screen.dart';
import '../../features/auth/presentation/pages/verify_email_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(
      name: AppRoutes.completeProfile,
      page: () => const CompleteProfileScreen(),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
  ];
}
