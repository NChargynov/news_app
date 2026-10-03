import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/features/news/data/model/news_article_model.dart';
import 'package:news_app/features/news/data/remote/api/news_data_source.dart';

abstract final class _ApiPath {
  static const String everyThing =
      "everything?q=football&from=2026-09-03&sortBy=publishedAt&apiKey=$apiKey";
  static const String apiKey = "9941da606ad2474c8a3c60939772cada";
}


@LazySingleton(as: NewsDataSource)
class NewsDataSourceImpl implements NewsDataSource {
  const NewsDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<List<NewsArticleModel>> getEverythingArticles() async {
    final response = await dio.get(_ApiPath.everyThing);
    return NewsArticleModel.fromJsonList(response.data["articles"]);
  }
}
