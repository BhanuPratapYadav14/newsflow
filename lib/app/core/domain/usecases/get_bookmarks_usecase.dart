import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetBookmarksUseCase {
  final NewsRepository repository;

  GetBookmarksUseCase(this.repository);

  Future<List<ArticleEntity>> call() {
    return repository.getBookmarks();
  }
}
