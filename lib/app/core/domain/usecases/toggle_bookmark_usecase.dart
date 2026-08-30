import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class ToggleBookmarkUseCase {
  final NewsRepository repository;

  ToggleBookmarkUseCase(this.repository);

  Future<void> call(ArticleEntity article) {
    return repository.toggleBookmark(article);
  }
}
