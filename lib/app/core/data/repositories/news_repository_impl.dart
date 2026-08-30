import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ArticleEntity>> getTopHeadlines({required String category, required int page}) async {
    return await remoteDataSource.fetchTopHeadlines(category: category, page: page);
  }

  @override
  Future<List<ArticleEntity>> getLatestNews({required String category, required int page}) async {
    return await remoteDataSource.fetchLatestNews(category: category, page: page);
  }

  @override
  Future<List<ArticleEntity>> getBookmarks() async {
    return await localDataSource.getBookmarks();
  }

  @override
  Future<void> toggleBookmark(ArticleEntity article) async {
    final model = ArticleModel.fromEntity(article);
    await localDataSource.toggleBookmark(model);
  }

  @override
  bool isBookmarked(ArticleEntity article) {
    return localDataSource.isBookmarked(article.url);
  }
}
