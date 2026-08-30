import 'package:hive_flutter/hive_flutter.dart';
import '../../utils/app_logger.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleModel>> getBookmarks();
  Future<void> toggleBookmark(ArticleModel article);
  bool isBookmarked(String url);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  static const String _boxName = 'bookmarksBox';
  late final Box<Map> _box;

  NewsLocalDataSourceImpl() {
    _box = Hive.box<Map>(_boxName);
  }

  @override
  Future<List<ArticleModel>> getBookmarks() async {
    final List<ArticleModel> loaded = [];
    for (var key in _box.keys) {
      final value = _box.get(key);
      if (value != null) {
        try {
          final Map<String, dynamic> map = Map<String, dynamic>.from(value);
          loaded.add(ArticleModel.fromJson(map));
        } catch (e, stackTrace) {
          AppLogger.e('Failed to parse bookmarked article from Hive', e, stackTrace);
        }
      }
    }
    return loaded;
  }

  @override
  Future<void> toggleBookmark(ArticleModel article) async {
    if (isBookmarked(article.url)) {
      await _box.delete(article.url);
    } else {
      await _box.put(article.url, article.toJson());
    }
  }

  @override
  bool isBookmarked(String url) {
    return _box.containsKey(url);
  }
}
