import 'package:get/get.dart';
import '../domain/entities/article_entity.dart';
import '../domain/entities/source_entity.dart';
import '../domain/repositories/news_repository.dart';
import '../domain/usecases/get_bookmarks_usecase.dart';
import '../domain/usecases/toggle_bookmark_usecase.dart';

class BookmarkController extends GetxController {
  late final GetBookmarksUseCase _getBookmarksUseCase;
  late final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  late final NewsRepository _repository;

  final RxList<ArticleEntity> bookmarkedArticles = <ArticleEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<NewsRepository>();
    _getBookmarksUseCase = GetBookmarksUseCase(_repository);
    _toggleBookmarkUseCase = ToggleBookmarkUseCase(_repository);
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final list = await _getBookmarksUseCase();
      bookmarkedArticles.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookmarks: $e');
    }
  }

  bool isBookmarked(ArticleEntity article) {
    return bookmarkedArticles.any((element) => element.url == article.url);
  }

  bool isBookmarkedByUrl(String url) {
    return bookmarkedArticles.any((element) => element.url == url);
  }

  Future<void> toggleBookmark(ArticleEntity article) async {
    final currentlyBookmarked = isBookmarked(article);
    try {
      await _toggleBookmarkUseCase(article);
      if (currentlyBookmarked) {
        bookmarkedArticles.removeWhere((element) => element.url == article.url);
        Get.snackbar(
          'Removed',
          'Article removed from bookmarks',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      } else {
        bookmarkedArticles.add(article);
        Get.snackbar(
          'Saved',
          'Article added to bookmarks',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      }
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update bookmarks: $e');
    }
  }

  Future<void> toggleBookmarkByFields({
    required String url,
    required String title,
    required String sourceName,
    required String urlToImage,
    required String publishedAt,
    required String author,
  }) async {
    final article = ArticleEntity(
      url: url,
      title: title,
      source: SourceEntity(name: sourceName),
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      author: author,
    );
    await toggleBookmark(article);
  }
}
