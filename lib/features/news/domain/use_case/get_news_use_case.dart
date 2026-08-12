import 'package:injectable/injectable.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';

@LazySingleton()
final class GetNewsUseCase {
  GetNewsUseCase({required this.repository});

  final NewsRepository repository;

  Future<List<NewsEntity>> call() async {
    return repository.getNews();
  }
}
