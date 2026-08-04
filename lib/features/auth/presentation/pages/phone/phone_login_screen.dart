import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/phone_auth_controller.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PhoneAuthController controller = Get.find<PhoneAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                prefixText: '+91 ',
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isSendingOtp.value
                      ? null
                      : controller.sendOtp,
                  child: controller.isSendingOtp.value
                      ? const CircularProgressIndicator()
                      : const Text('Send OTP'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
