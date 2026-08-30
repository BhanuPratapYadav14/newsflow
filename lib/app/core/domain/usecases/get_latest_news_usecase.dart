import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetLatestNewsUseCase {
  final NewsRepository repository;

  GetLatestNewsUseCase(this.repository);

  Future<List<ArticleEntity>> call({required String category, required int page}) {
    return repository.getLatestNews(category: category, page: page);
  }
}
