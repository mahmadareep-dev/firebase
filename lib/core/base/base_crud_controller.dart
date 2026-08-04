import 'package:flutter/material.dart';

import '../widgets/feedbacks/app_snackbar.dart';
import 'base_controller.dart';

abstract class BaseCrudController extends BaseController {
  @protected
  void showSuccess(String message) {
    AppSnackbar.success(message);
  }

  @protected
  void showError(String message) {
    AppSnackbar.error(message);
  }

  @protected
  void showInfo(String message) {
    AppSnackbar.info(message);
  }
}
