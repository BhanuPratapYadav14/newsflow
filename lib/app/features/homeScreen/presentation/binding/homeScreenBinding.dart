import 'package:get/get.dart';

import '../controller/homeScreenController.dart';
class HomeScreenBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeController());
  }
}