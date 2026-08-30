import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/domain/entities/article_entity.dart';
import '../../../../core/domain/repositories/news_repository.dart';
import '../../../../core/domain/usecases/search_news_usecase.dart';

class NewsSearchController extends GetxController {
  late final SearchNewsUseCase _searchNewsUseCase;

  final TextEditingController searchTextController = TextEditingController();
  final RxList<ArticleEntity> searchResults = <ArticleEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final repository = Get.find<NewsRepository>();
    _searchNewsUseCase = SearchNewsUseCase(repository);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> performSearch() async {
    final text = searchTextController.text.trim();
    if (text.isEmpty) return;

    try {
      isLoading.value = true;
      query.value = text;
      update();

      final results = await _searchNewsUseCase(query: text);
      searchResults.assignAll(results);
    } catch (e) {
      Get.snackbar('Search Error', 'Failed to perform search: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void clearSearch() {
    searchTextController.clear();
    searchResults.clear();
    query.value = '';
    update();
  }
}
