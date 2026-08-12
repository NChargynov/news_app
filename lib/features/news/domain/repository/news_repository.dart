import 'package:news_app/features/news/domain/models/news_model_entity.dart';

abstract interface class NewsRepository {
  Future<List<NewsEntity>> getNews();
}
