import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'features/auth/presentation/controllers/auth_session_controller.dart';
import 'features/auth/presentation/enum/auth_session_status.dart';
import 'features/auth/presentation/pages/home_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/phone/complete_profile_screen.dart';
import 'features/auth/presentation/pages/verify_email_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Project ID: ${Firebase.app().options.projectId}');
  debugPrint('App ID: ${Firebase.app().options.appId}');
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          home: child,
        );
      },
      child: const AuthSessionView(),
    );
  }
}

class AuthSessionView extends GetView<AuthSessionController> {
  const AuthSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.status.value) {
        case AuthSessionStatus.loading:
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );

        case AuthSessionStatus.unauthenticated:
          return const LoginScreen();

        case AuthSessionStatus.emailUnverified:
          return const VerifyEmailScreen();

        case AuthSessionStatus.profileIncomplete:
          return const CompleteProfileScreen();

        case AuthSessionStatus.authenticated:
          return const HomeScreen();
      }
    });
  }
}
