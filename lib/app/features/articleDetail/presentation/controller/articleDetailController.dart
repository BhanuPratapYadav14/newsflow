import 'package:get/get.dart';
import '../../../../core/domain/entities/article_entity.dart';
import '../../../../core/domain/entities/source_entity.dart';

class ArticleDetailController extends GetxController {
  late final ArticleEntity article;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ArticleEntity) {
      article = Get.arguments as ArticleEntity;
    } else {
      // Fallback if no article is passed
      article = ArticleEntity(
        source: SourceEntity(name: 'Unknown'),
        title: 'No Title Available',
        url: '',
        publishedAt: '',
      );
    }
  }
}
