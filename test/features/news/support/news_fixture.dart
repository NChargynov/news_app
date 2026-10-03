import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';

List<NewsArticleEntity> newsFixture(int count) => List.generate(
  count,
  (index) => NewsArticleEntity(
    author: 'Author $index',
    title: 'Article $index',
    description: 'Description $index',
    url: '',
    urlToImage: '',
    publishedAt: '',
    content: '',
  ),
);

class FakeNewsRepository implements NewsRepository {
  FakeNewsRepository(this.articles, {this.shouldFail = false});

  final List<NewsArticleEntity> articles;
  bool shouldFail;
  int requests = 0;

  @override
  Future<List<NewsArticleEntity>> getEverythingArticles() async {
    requests++;
    if (shouldFail) throw StateError('Тестовая ошибка');
    return articles;
  }
}
