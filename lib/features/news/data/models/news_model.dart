import 'package:news_app/core/util/transformable.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';

final class NewsModel with Transformable<NewsEntity>{
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  NewsModel({
    // required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      author: json['author'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'].toString())
          : null,
      content: json['content'] as String?,
    );
  }

  @override
  NewsEntity transform() {
    return NewsEntity(
      author: author ?? '',
      title: title ?? '',
      description: description ?? '',
      url: url ?? '',
      urlToImage: urlToImage ?? '',
      publishedAt: publishedAt ?? DateTime.now(),
      content: content ?? '',
    );
  }
}
