import '../entities/article_entity.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getTopHeadlines({required String category, required int page});
  Future<List<ArticleEntity>> getLatestNews({required String category, required int page});
  Future<List<ArticleEntity>> getBookmarks();
  Future<void> toggleBookmark(ArticleEntity article);
  bool isBookmarked(ArticleEntity article);
  Future<List<ArticleEntity>> searchNews({required String query});
}
