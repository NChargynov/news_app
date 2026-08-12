part of 'news_bloc.dart';

@immutable
sealed class NewsEvent {}

final class GetNewsEvent extends NewsEvent {}
