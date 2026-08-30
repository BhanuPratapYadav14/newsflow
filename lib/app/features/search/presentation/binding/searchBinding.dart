import 'package:get/get.dart';
import '../controller/searchController.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewsSearchController());
  }
}
