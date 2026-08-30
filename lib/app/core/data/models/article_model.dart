import '../../domain/entities/article_entity.dart';
import 'source_model.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel({
    required SourceModel super.source,
    super.author,
    required super.title,
    super.description,
    required super.url,
    super.urlToImage,
    required super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<dynamic, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(json['source'] as Map),
      author: json['author'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String? ?? '',
      content: json['content'] as String?,
    );
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      source: SourceModel(id: entity.source.id, name: entity.source.name),
      author: entity.author,
      title: entity.title,
      description: entity.description,
      url: entity.url,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
      content: entity.content,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': (source as SourceModel).toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}
