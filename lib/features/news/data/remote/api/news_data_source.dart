import 'package:news_app/features/news/data/model/news_article_model.dart';

abstract class NewsDataSource {
  Future<List<NewsArticleModel>> getEverythingArticles();
}
