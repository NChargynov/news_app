import 'package:news_app/features/news/domain/entity/news_article_entity.dart';

abstract class NewsRepository {
  Future<List<NewsArticleEntity>> getEverythingArticles();

  Future<NewsResponseEntity> getEverythingNewsPaging({
    required int pageSize,
    required int page,
  });
}
