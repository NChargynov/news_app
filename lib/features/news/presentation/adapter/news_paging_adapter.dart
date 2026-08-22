import 'package:injectable/injectable.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';
import 'package:paging_view/paging_view.dart';

@injectable
class NewsPagingAdapter extends DataSource<int, NewsEntity> {
  static const int pageSize = 20;
  static const int firstPage = 1;

  final NewsRepository newsRepository;

  NewsPagingAdapter({required this.newsRepository});

  @override
  Future<LoadResult<int, NewsEntity>> load(LoadAction<int> action) async {
    //логика работы пагинации
    return switch (action) {
      //При открытии экрана, при свайпе
      Refresh() => _getData(firstPage),
      //При открытии следующей страницы
      Append(:final key) => _getData(key),
      //При открытии предыдущей страницы, не нужно
      Prepend() => None(),
    };
  }

  Future<LoadResult<int, NewsEntity>> _getData(int page) async {
    // Получение данных из бэкенда

    try {
      final NewsResponseEntity newsResponseEntity = await newsRepository
          .getNewsPaging(pageSize: pageSize, page: page);

      //копим количество загруженных элементов
      final int loadedCount =
          ((page - 1) * pageSize) + (newsResponseEntity.articles.length);

      final bool hasMoreData =
          newsResponseEntity.articles.isNotEmpty &&
          page < 5 &&
          loadedCount < newsResponseEntity.totalResults;

      int? nextPage;

      if (hasMoreData) {
        nextPage = page + 1;
      }
      return Success(
        page: PageData(data: newsResponseEntity.articles, appendKey: nextPage),
      );
    } catch (e) {
      return Failure(error: e);
    }
  }
}
