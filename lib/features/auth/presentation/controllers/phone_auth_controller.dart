import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/usecases/send_phone_otp_usecase.dart';
import '../../domain/usecases/verify_phone_otp_usecase.dart';
import '../pages/phone/otp_screen.dart';

class PhoneAuthController extends GetxController {
  final SendPhoneOtpUseCase sendPhoneOtpUseCase;
  final VerifyPhoneOtpUseCase verifyPhoneOtpUseCase;

  PhoneAuthController({
    required this.sendPhoneOtpUseCase,
    required this.verifyPhoneOtpUseCase,
  });

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final RxBool isSendingOtp = false.obs;
  final RxBool isVerifyingOtp = false.obs;

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.length != 10) {
      _showError('Please enter a valid 10-digit mobile number');
      return;
    }

    try {
      isSendingOtp.value = true;

      await sendPhoneOtpUseCase(
        phoneNumber: '+91$phone',
        onCodeSent: (verificationId) {
          isSendingOtp.value = false;

          Get.to(() => OtpScreen(verificationId: verificationId));
        },
        onVerificationFailed: (message) {
          isSendingOtp.value = false;
          _showError(message);
        },
        onAutoVerified: () {
          isSendingOtp.value = false;
        },
      );
    } catch (_) {
      isSendingOtp.value = false;
      _showError('Unable to send OTP. Please try again.');
    }
  }

  Future<void> verifyOtp({required String verificationId}) async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      _showError('Please enter valid 6-digit OTP');
      return;
    }

    try {
      isVerifyingOtp.value = true;

      await verifyPhoneOtpUseCase(verificationId: verificationId, smsCode: otp);
      otpController.clear();
      phoneController.clear();

      Get.until((route) => route.isFirst);
    } on AppException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Something went wrong while verifying OTP');
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
