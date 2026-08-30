import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constant/appConstant.dart';
import '../../utils/app_logger.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> fetchTopHeadlines({required String category, required int page});
  Future<List<ArticleModel>> fetchLatestNews({required String category, required int page});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ArticleModel>> fetchTopHeadlines({required String category, required int page}) async {
    final queryCategory = category.toLowerCase();
    final url = Uri.parse(
        '${AppConstant.BASE_URL}top-headlines?country=us&category=$queryCategory&pageSize=10&page=$page&apiKey=${AppConstant.API_KEY}');
    try {
      AppLogger.i('GET TopHeadlines request to: $url');
      final response = await client.get(url);
      AppLogger.d('GET TopHeadlines response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articlesJson = data['articles'] ?? [];
          AppLogger.d('Fetched ${articlesJson.length} headlines successfully.');
          return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
        } else {
          final errorMsg = data['message'] ?? 'Failed to load headlines';
          AppLogger.w('API Warning: $errorMsg');
          throw Exception(errorMsg);
        }
      } else {
        AppLogger.w('HTTP Response failed: status code ${response.statusCode}');
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Exception inside fetchTopHeadlines', e, stackTrace);
      throw Exception('Error occurred: $e');
    }
  }

  @override
  Future<List<ArticleModel>> fetchLatestNews({required String category, required int page}) async {
    final weekly = DateTime.now().subtract(const Duration(days: 7)).toIso8601String().split('T').first;
    final query = category == 'general' ? 'news' : category;
    final url = Uri.parse(
        '${AppConstant.BASE_URL}everything?q=$query&from=$weekly&sortBy=publishedAt&pageSize=10&page=$page&apiKey=${AppConstant.API_KEY}');
    try {
      AppLogger.i('GET LatestNews request to: $url');
      final response = await client.get(url);
      AppLogger.d('GET LatestNews response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articlesJson = data['articles'] ?? [];
          AppLogger.d('Fetched ${articlesJson.length} latest articles successfully.');
          return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
        } else {
          final errorMsg = data['message'] ?? 'Failed to load latest news';
          AppLogger.w('API Warning: $errorMsg');
          throw Exception(errorMsg);
        }
      } else {
        AppLogger.w('HTTP Response failed: status code ${response.statusCode}');
        throw Exception('Failed to load latest news: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Exception inside fetchLatestNews', e, stackTrace);
      throw Exception('Error occurred: $e');
    }
  }
}
