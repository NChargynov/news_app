import 'package:equatable/equatable.dart';
import 'package:news_app/domain/entity/news_article_entity.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoading extends NewsState {
  const NewsLoading();
}

class NewsSuccess extends NewsState {
  const NewsSuccess({required this.news});

  final List<NewsArticleEntity> news;

  @override
  List<Object?> get props => [news];
}

class NewsFailure extends NewsState {
  const NewsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
