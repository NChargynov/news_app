part of 'news_bloc.dart';

@immutable
sealed class NewsState {}

final class NewsInitial extends NewsState {}

final class LoadingNewsState extends NewsState {}

final class ErrorNewsState extends NewsState {
  ErrorNewsState({required this.message});

  final String message;
}

final class LoadedNewsState extends NewsState {
  LoadedNewsState({required this.news});

  final List<NewsEntity> news;
}
