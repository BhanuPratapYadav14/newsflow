import 'package:get/get.dart';

import '../controller/splashController.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => SplashController());
  }
}