import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/connectivity_controller.dart';

class OfflineBanner extends GetView<ConnectivityController> {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isOffline) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: Colors.red,
        padding: const EdgeInsets.all(12),
        child: const SafeArea(
          bottom: false,
          child: Text(
            'No Internet Connection',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }
}
