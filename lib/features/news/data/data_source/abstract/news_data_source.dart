import 'package:news_app/features/news/data/models/news_model.dart';

abstract interface class NewsDataSource {
  Future<List<NewsModel>> getNews();

  Future<NewsResponseModel> getNewsPaging({
    required int pageSize,
    required int page,
  });
}
