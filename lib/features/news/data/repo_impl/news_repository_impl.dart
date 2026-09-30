import 'package:news_app/features/news/data/remote/api/news_data_source.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl({required this.dataSource});

  final NewsDataSource dataSource;

  @override
  Future<List<NewsArticleEntity>> getEverythingArticles() async{
    final result = await dataSource.getEverythingArticles();
    return result.map((model) => model.fromModelToEntity()).toList();
  }
}
