import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/bloc/news_state.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({required this.newsRepository}) : super(NewsInitial()) {
    on<GetEverythingEvent>(_getEverythingArticles);
  }

  final NewsRepository newsRepository;

  FutureOr<void> _getEverythingArticles(
    GetEverythingEvent event,
    Emitter<NewsState> emit,
  ) async {

    emit(NewsLoading());
    try {
      final result = await newsRepository.getEverythingArticles();
      emit(NewsSuccess(news: result));
    } catch (error) {
      emit(NewsFailure("Новостей нет"));
    }
  }
}
