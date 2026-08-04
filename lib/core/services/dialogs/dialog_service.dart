import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogService {
  DialogService._();

  static bool get isOpen => Get.isDialogOpen ?? false;

  static void close() {
    if (isOpen) {
      Get.back();
    }
  }

  static Future<void> showLoading({
    String message = 'Please wait...',
    bool barrierDismissible = false,
  }) async {
    if (isOpen) return;

    await Get.dialog(
      PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(message, style: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<bool> confirm({
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  static Future<void> success({
    String title = 'Success',
    required String message,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [ElevatedButton(onPressed: Get.back, child: const Text('OK'))],
      ),
    );
  }

  static Future<void> error({
    String title = 'Error',
    required String message,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [ElevatedButton(onPressed: Get.back, child: const Text('OK'))],
      ),
    );
  }
}
