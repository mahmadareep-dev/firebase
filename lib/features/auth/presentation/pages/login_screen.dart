import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/core.dart';
import '../controllers/auth_controller.dart';
import 'forgot_password_screen.dart';
import 'phone/phone_login_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            SizedBox(
              height: 200.h,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 20.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
                    AppTextField(
                      controller: controller.emailController,
                      label: "Email",
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(AppIcons.email),
                    ),

                    SizedBox(height: 20.h),

                    AppPasswordField(
                      controller: controller.passwordController,
                      textInputAction: TextInputAction.done,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const ForgotPasswordScreen());
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ),

                    SizedBox(height: 28.h),
                    Obx(
                      () => PrimaryButton(
                        text: "Sign In",
                        isLoading: controller.isLoading.value,
                        onPressed: controller.loginWithEmail,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const SignupScreen());
                                },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    SecondaryButton(
                      text: "Continue with Phone",
                      leading: const Icon(Icons.phone),
                      onPressed: () {
                        Get.to(() => const PhoneLoginScreen());
                      },
                    ),

                    SizedBox(height: 16.h),

                    Obx(
                      () => SecondaryButton(
                        text: "Continue with Google",
                        leading: const Icon(Icons.g_mobiledata, size: 28),
                        isLoading: controller.isGoogleLoading.value,
                        onPressed: controller.loginWithGoogle,
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
