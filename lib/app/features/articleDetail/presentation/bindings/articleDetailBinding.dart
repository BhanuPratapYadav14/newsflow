import 'package:get/get.dart';
import '../controller/articleDetailController.dart';

class ArticleDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleDetailController());
  }
}
