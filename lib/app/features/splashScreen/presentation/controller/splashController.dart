import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/appPageName.dart';
class SplashController extends GetxController {
  final RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
  progress.value = 0.0;

  for (int i = 1; i <= 10; i++) {
    await Future.delayed(const Duration(milliseconds: 300));
    progress.value = i / 10;
  }

  if (progress.value == 1.0) {
    debugPrint('progress: ${progress.value}');
    Get.offAllNamed(AppPageName.home);
  }
}
}