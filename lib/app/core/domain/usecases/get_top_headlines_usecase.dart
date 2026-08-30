import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlinesUseCase {
  final NewsRepository repository;

  GetTopHeadlinesUseCase(this.repository);

  Future<List<ArticleEntity>> call({required String category, required int page}) {
    return repository.getTopHeadlines(category: category, page: page);
  }
}
