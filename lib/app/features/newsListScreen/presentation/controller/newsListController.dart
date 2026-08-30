import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/bookmark_controller.dart';
import '../../../../core/domain/entities/article_entity.dart';
import '../../../../core/domain/repositories/news_repository.dart';
import '../../../../core/domain/usecases/get_latest_news_usecase.dart';
import '../../../../core/domain/usecases/get_top_headlines_usecase.dart';
import '../../../../core/enums/newsCategoriesEnums.dart';
import '../../../homeScreen/presentation/controller/homeScreenController.dart';

class NewsListController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  
  late final GetTopHeadlinesUseCase _getTopHeadlinesUseCase;
  late final GetLatestNewsUseCase _getLatestNewsUseCase;

  final RxString mode = 'featured'.obs; // 'featured' or 'latest'
  final RxList<ArticleEntity> articlesList = <ArticleEntity>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    final repository = Get.find<NewsRepository>();
    _getTopHeadlinesUseCase = GetTopHeadlinesUseCase(repository);
    _getLatestNewsUseCase = GetLatestNewsUseCase(repository);
    
    // Parse navigation arguments
    if (Get.arguments != null && Get.arguments is String) {
      mode.value = Get.arguments;
    }
    
    // Seed list with initial articles from HomeController to avoid initial fetch delay
    final initialArticles = mode.value == 'latest' 
        ? homeController.latestArticles 
        : homeController.articles;
        
    articlesList.assignAll(initialArticles);
    currentPage.value = 1;
    hasMore.value = initialArticles.length >= 10;

    // Attach scroll listener for pagination
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMoreArticles();
    }
  }

  Future<void> loadMoreArticles() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;
      update();

      final nextPage = currentPage.value + 1;
      final category = homeController.selectedCategory.value.name;

      List<ArticleEntity> newArticles;
      if (mode.value == 'latest') {
        newArticles = await _getLatestNewsUseCase(category: category, page: nextPage);
      } else {
        newArticles = await _getTopHeadlinesUseCase(category: category, page: nextPage);
      }

      if (newArticles.isEmpty) {
        hasMore.value = false;
      } else {
        articlesList.addAll(newArticles);
        currentPage.value = nextPage;
        if (newArticles.length < 10) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load more articles: $e');
    } finally {
      isLoadingMore.value = false;
      update();
    }
  }

  Future<void> refreshNews() async {
    try {
      currentPage.value = 1;
      hasMore.value = true;
      
      final category = homeController.selectedCategory.value.name;
      List<ArticleEntity> refreshedArticles;
      
      if (mode.value == 'latest') {
        refreshedArticles = await _getLatestNewsUseCase(category: category, page: 1);
        homeController.latestArticles.assignAll(refreshedArticles);
      } else {
        refreshedArticles = await _getTopHeadlinesUseCase(category: category, page: 1);
        homeController.articles.assignAll(refreshedArticles);
      }
      
      articlesList.assignAll(refreshedArticles);
    } catch (e) {
      Get.snackbar('Error', 'Failed to refresh news: $e');
    }
  }

  void toggleBookmark(ArticleEntity article) {
    Get.find<BookmarkController>().toggleBookmark(article);
  }

  bool isBookmarked(ArticleEntity article) {
    return Get.find<BookmarkController>().isBookmarked(article);
  }

  String get categoryLabel => homeController.selectedCategory.value.label;
  bool get isLoading => homeController.isLoading.value;
}
