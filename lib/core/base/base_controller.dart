import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  void startLoading() => isLoading.value = true;

  void stopLoading() => isLoading.value = false;

  void startSaving() => isSaving.value = true;

  void stopSaving() => isSaving.value = false;

  void setLoading(bool value) => isLoading.value = value;

  void setSaving(bool value) => isSaving.value = value;

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = '';
  }
}
