import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/connectivity_controller.dart';

class NoInternetWidget extends GetView<ConnectivityController> {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 90),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.retry,
              child: const Text('Retry'),
            ),
          ],
        );
      }),
    );
  }
}
