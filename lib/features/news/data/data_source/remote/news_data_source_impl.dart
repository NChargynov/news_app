import 'package:dio/dio.dart';
import 'package:news_app/features/news/data/data_source/abstract/news_data_source.dart';
import 'package:news_app/features/news/data/models/news_model.dart';

final class _ApiPath {
  static const String getNews =
      'https://newsapi.org/v2/everything?q=good-things&from=2026-08-07&to=2026-08-07&sortBy=popularity&apiKey=60019dbd83e541ec8bcdc42081892ec1';
}

class NewsDataSourceImpl implements NewsDataSource {
  NewsDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<NewsModel>> getNews() async {
    final Response response = await dio.get(_ApiPath.getNews);
    final list = response.data['articles'] as List;
    final List<NewsModel> news = [];
    list.forEach((model) {
      news.add(NewsModel.fromJson(model));
    });
    return news;
  }
}
