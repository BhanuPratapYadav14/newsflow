import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constant/appConstant.dart';
import '../../utils/app_logger.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> fetchTopHeadlines({required String category, required int page});
  Future<List<ArticleModel>> fetchLatestNews({required String category, required int page});
  Future<List<ArticleModel>> searchNews({required String query});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  void _handleErrorResponse(http.Response response, String defaultMsg) {
    if (response.statusCode == 429) {
      throw Exception("Oops! We've reached the news provider's daily limit of 100 free requests. Please try again later or check back tomorrow!");
    }

    String? apiErrorMessage;
    try {
      final Map<String, dynamic> data = json.decode(response.body);
      final String? code = data['code']?.toString();
      final String? msg = data['message']?.toString();

      if (code == 'rateLimited' || 
          (msg != null && (msg.toLowerCase().contains('rate limit') || msg.toLowerCase().contains('too many requests')))) {
        throw Exception("Oops! We've reached the news provider's daily limit of 100 free requests. Please try again later or check back tomorrow!");
      }

      if (msg != null) {
        apiErrorMessage = msg;
      }
    } catch (e) {
      if (e.toString().contains("Oops!")) {
        rethrow;
      }
    }

    if (apiErrorMessage != null) {
      throw Exception(apiErrorMessage);
    }
    throw Exception('$defaultMsg (Status: ${response.statusCode})');
  }

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
        _handleErrorResponse(response, 'Failed to load headlines');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Exception inside fetchTopHeadlines', e, stackTrace);
      rethrow;
    }
    throw Exception('Failed to fetch headlines');
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
        _handleErrorResponse(response, 'Failed to load latest news');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Exception inside fetchLatestNews', e, stackTrace);
      rethrow;
    }
    throw Exception('Failed to fetch latest news');
  }

  @override
  Future<List<ArticleModel>> searchNews({required String query}) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
        '${AppConstant.BASE_URL}everything?q=$encodedQuery&sortBy=relevance&pageSize=20&apiKey=${AppConstant.API_KEY}');
    try {
      AppLogger.i('GET Search request to: $url');
      final response = await client.get(url);
      AppLogger.d('GET Search response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articlesJson = data['articles'] ?? [];
          AppLogger.d('Search results: fetched ${articlesJson.length} articles successfully.');
          return articlesJson.map((json) => ArticleModel.fromJson(json)).toList();
        } else {
          final errorMsg = data['message'] ?? 'Failed to perform search';
          AppLogger.w('API Warning: $errorMsg');
          throw Exception(errorMsg);
        }
      } else {
        AppLogger.w('HTTP Response failed: status code ${response.statusCode}');
        _handleErrorResponse(response, 'Failed to perform search');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Exception inside searchNews', e, stackTrace);
      rethrow;
    }
    throw Exception('Failed to execute search');
  }
}
