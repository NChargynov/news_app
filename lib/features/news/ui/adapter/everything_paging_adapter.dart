import 'package:injectable/injectable.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';
import 'package:paging_view/paging_view.dart';

@injectable
class EverythingPagingAdapter extends DataSource<int, NewsArticleEntity> {
  static const int pageSize = 20;
  static const int firstPage = 1;

  EverythingPagingAdapter(this.newsRepository);

  final NewsRepository newsRepository;

  @override
  Future<LoadResult<int, NewsArticleEntity>> load(
    LoadAction<int> action,
  ) async {
    return switch (action) {
      Refresh() => _fetchData(firstPage),
      Append(:final key) => _fetchData(key),
      Prepend() => None(),
    };
  }

  Future<LoadResult<int, NewsArticleEntity>> _fetchData(int page) async {
    // получение данных из бэкенда

    try {
      final NewsResponseEntity newsPage = await newsRepository
          .getEverythingNewsPaging(page: page, pageSize: pageSize);

      // копим количество загруженных элементов
      final int loadedCount =
          ((page - 1) * pageSize) + newsPage.articles.length;

      final bool hasMore =
          newsPage.articles.isNotEmpty && loadedCount < newsPage.totalResults && page < 5 ;

      int? nextPage;

      if (hasMore) {
        nextPage = page + 1;
      }

      return Success(
        page: PageData(data: newsPage.articles, appendKey: nextPage),
      );
    } catch (error) {
      return Failure(error: error);
    }
  }
}
