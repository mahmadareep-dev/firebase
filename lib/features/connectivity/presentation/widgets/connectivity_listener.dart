import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/connectivity_controller.dart';
import 'offline_banner.dart';

class ConnectivityListener extends GetView<ConnectivityController> {
  const ConnectivityListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OfflineBanner(),
        Expanded(child: child),
      ],
    );
  }
}
