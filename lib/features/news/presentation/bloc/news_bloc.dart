import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/domain/use_case/get_news_use_case.dart';

part 'news_event.dart';

part 'news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNewsUseCase getNews;

  NewsBloc({required this.getNews}) : super(NewsInitial()) {
    on<NewsEvent>((event, emit) async {
      try {
        emit(LoadingNewsState());
        final List<NewsEntity> list = await getNews.call();
        emit(LoadedNewsState(news: list));
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        emit(ErrorNewsState(message: "КАПЕЦ ТЫ ЛОХ!!!"));
      }
    });
  }
}
