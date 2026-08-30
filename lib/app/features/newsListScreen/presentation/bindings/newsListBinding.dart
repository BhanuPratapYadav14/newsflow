import 'package:get/get.dart';
import '../controller/newsListController.dart';

class NewsListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsListController());
  }
}
