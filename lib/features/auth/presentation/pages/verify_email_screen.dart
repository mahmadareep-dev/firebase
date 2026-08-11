import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/auth_session_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final AuthSessionController sessionController =
        Get.find<AuthSessionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            onPressed: authController.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 80),

            const SizedBox(height: 20),

            const Text(
              'Verify your email address',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text(
              'We sent a verification link to\n'
              '${authController.currentUser?.email ?? ''}',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.isCheckingVerification.value
                      ? null
                      : () async {
                          authController.isCheckingVerification.value = true;

                          try {
                            await sessionController.refreshSession();
                          } finally {
                            authController.isCheckingVerification.value = false;
                          }
                        },
                  child: authController.isCheckingVerification.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("I've Verified My Email"),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Obx(
              () => TextButton(
                onPressed: authController.isSendingVerification.value
                    ? null
                    : authController.resendVerificationEmail,
                child: Text(
                  authController.isSendingVerification.value
                      ? 'Sending...'
                      : authController.resendVerificationSeconds.value > 0
                      ? 'Resend in ${authController.resendVerificationSeconds.value}s'
                      : 'Resend Verification Email',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
