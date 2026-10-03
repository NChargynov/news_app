import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/presentation/models/news_sections.dart';

import 'support/news_fixture.dart';

void main() {
  group('NewsSections', () {
    for (final count in [0, 1, 2, 3, 4, 5, 7, 10, 100]) {
      test('распределяет $count статей без потерь и перестановок', () {
        final articles = newsFixture(count);
        final sections = NewsSections.fromArticles(articles);
        final groups = [
          sections.trending,
          sections.newReleases,
          sections.selectedForYou,
        ];

        expect(groups.expand((group) => group), orderedEquals(articles));
        final sizes = groups.map((group) => group.length).toList()..sort();
        expect(sizes.last - sizes.first, lessThanOrEqualTo(1));
        expect(sections.isEmpty, count == 0);
      });
    }

    test('остаток распределяется между первыми секциями', () {
      final sections = NewsSections.fromArticles(newsFixture(5));
      expect(sections.trending.length, 2);
      expect(sections.newReleases.length, 2);
      expect(sections.selectedForYou.length, 1);
    });

    test('секции не меняют исходный список и защищены от изменений', () {
      final articles = newsFixture(4);
      final sections = NewsSections.fromArticles(articles);
      expect(articles.length, 4);
      articles.clear();
      expect(sections.trending.length, 2);
      expect(sections.newReleases.length, 1);
      expect(sections.selectedForYou.length, 1);
      expect(sections.trending.clear, throwsUnsupportedError);
    });

    test('поиск учитывает регистр, пробелы и сохраняет секцию статьи', () {
      final sections = NewsSections.fromArticles(newsFixture(6));
      final filtered = sections.matching('  ARTICLE 2 ');
      expect(filtered.trending, isEmpty);
      expect(filtered.newReleases, [sections.newReleases.first]);
      expect(filtered.selectedForYou, isEmpty);
      expect(sections.newReleases.length, 2);
      expect(sections.matching('   '), same(sections));
      expect(sections.matching('нет совпадений').isEmpty, isTrue);
    });

    test('поиск работает по автору и описанию', () {
      const article = NewsArticleEntity(
        author: 'Редакция',
        title: 'Матч',
        description: 'Футбольный финал',
        url: '',
        urlToImage: '',
        publishedAt: '',
        content: '',
      );
      final sections = NewsSections.fromArticles([article]);
      expect(sections.matching('РЕДАКЦИЯ').trending, [article]);
      expect(sections.matching('финал').trending, [article]);
    });
  });
}
