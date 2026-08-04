import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarService {
  SnackbarService._();

  static void success(
    String message, {
    String title = 'Success',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: duration,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void error(
    String message, {
    String title = 'Error',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: duration,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void warning(
    String message, {
    String title = 'Warning',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: duration,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
    );
  }

  static void info(
    String message, {
    String title = 'Info',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: duration,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }
}
