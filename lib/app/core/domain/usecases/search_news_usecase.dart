import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class SearchNewsUseCase {
  final NewsRepository repository;

  SearchNewsUseCase(this.repository);

  Future<List<ArticleEntity>> call({required String query}) {
    return repository.searchNews(query: query);
  }
}
