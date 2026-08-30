import 'package:get/get.dart';
import '../../../../core/domain/entities/article_entity.dart';
import '../../../../core/domain/repositories/news_repository.dart';
import '../../../../core/domain/usecases/get_latest_news_usecase.dart';
import '../../../../core/domain/usecases/get_top_headlines_usecase.dart';
import '../../../../core/enums/newsCategoriesEnums.dart';

class HomeController extends GetxController {
  late final GetTopHeadlinesUseCase _getTopHeadlinesUseCase;
  late final GetLatestNewsUseCase _getLatestNewsUseCase;

  Rx<NewsCategory> selectedCategory = NewsCategory.general.obs;
  RxBool isLoading = false.obs;
  RxList<ArticleEntity> articles = <ArticleEntity>[].obs; // Top headlines
  RxList<ArticleEntity> latestArticles = <ArticleEntity>[].obs; // Latest news
  Rxn<ArticleEntity> featuredArticle = Rxn<ArticleEntity>();

  @override
  void onInit() {
    super.onInit();
    final repository = Get.find<NewsRepository>();
    _getTopHeadlinesUseCase = GetTopHeadlinesUseCase(repository);
    _getLatestNewsUseCase = GetLatestNewsUseCase(repository);
    fetchNews();
  }

  void selectCategory(NewsCategory category) {
    selectedCategory.value = category;
    fetchNews();
    update();
  }

  bool isSelected(NewsCategory category) {
    return selectedCategory.value == category;
  }

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      update();
      
      // Fetch both top headlines and latest news from today concurrently
      final results = await Future.wait([
        _getTopHeadlinesUseCase(category: selectedCategory.value.name, page: 1),
        _getLatestNewsUseCase(category: selectedCategory.value.name, page: 1),
      ]);

      final fetchedHeadlines = results[0];
      final fetchedLatest = results[1];

      articles.assignAll(fetchedHeadlines);
      latestArticles.assignAll(fetchedLatest);

      if (fetchedHeadlines.isNotEmpty) {
        featuredArticle.value = fetchedHeadlines.first;
      } else {
        featuredArticle.value = null;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      featuredArticle.value = null;
      articles.clear();
      latestArticles.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }
}