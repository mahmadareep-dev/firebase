import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/phone_auth_controller.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final PhoneAuthController controller = Get.find<PhoneAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isVerifyingOtp.value
                      ? null
                      : () {
                          controller.verifyOtp(verificationId: verificationId);
                        },
                  child: controller.isVerifyingOtp.value
                      ? const CircularProgressIndicator()
                      : const Text('Verify OTP'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
