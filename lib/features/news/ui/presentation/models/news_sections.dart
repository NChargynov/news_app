import 'package:news_app/features/news/domain/entity/news_article_entity.dart';

/// Представление одной выдачи API в трёх последовательных секциях экрана.
class NewsSections {
  const NewsSections._({
    required this.trending,
    required this.newReleases,
    required this.selectedForYou,
  });

  factory NewsSections.fromArticles(List<NewsArticleEntity> articles) {
    final baseSize = articles.length ~/ 3;
    final remainder = articles.length % 3;
    final firstEnd = baseSize + (remainder > 0 ? 1 : 0);
    final secondEnd = firstEnd + baseSize + (remainder > 1 ? 1 : 0);

    return NewsSections._(
      trending: List.unmodifiable(articles.sublist(0, firstEnd)),
      newReleases: List.unmodifiable(articles.sublist(firstEnd, secondEnd)),
      selectedForYou: List.unmodifiable(articles.sublist(secondEnd)),
    );
  }

  final List<NewsArticleEntity> trending;
  final List<NewsArticleEntity> newReleases;
  final List<NewsArticleEntity> selectedForYou;

  bool get isEmpty =>
      trending.isEmpty && newReleases.isEmpty && selectedForYou.isEmpty;

  /// Поиск внутри готовых секций не меняет исходный порядок и принадлежность.
  NewsSections matching(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return this;

    bool matches(NewsArticleEntity article) =>
        article.title.toLowerCase().contains(normalizedQuery) ||
        article.author.toLowerCase().contains(normalizedQuery) ||
        article.description.toLowerCase().contains(normalizedQuery);

    return NewsSections._(
      trending: List.unmodifiable(trending.where(matches)),
      newReleases: List.unmodifiable(newReleases.where(matches)),
      selectedForYou: List.unmodifiable(selectedForYou.where(matches)),
    );
  }
}
