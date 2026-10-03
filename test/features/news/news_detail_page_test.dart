import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';
import 'package:news_app/features/news/ui/presentation/news_detail_page.dart';
import 'package:news_app/features/news/ui/presentation/widgets/article_tile.dart';

import 'home_page_test.dart' show pumpHome;
import 'support/news_fixture.dart';

const _article = NewsArticleEntity(
  author: 'Michelle Obama',
  title: 'Becoming',
  description: 'An intimate, powerful, and inspiring memoir.',
  url: 'https://example.com/news/becoming',
  urlToImage: '',
  publishedAt: '2018-11-13T14:48:00Z',
  content:
      'In a life filled with meaning and accomplishment, Michelle Obama '
      'has emerged as one of the most iconic and compelling women of our era. '
      'This final sentence must remain available when the article is expanded.',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Montserrat')
      ..addFont(
        rootBundle.load('assets/fonts/montserrat/Montserrat-Variable.ttf'),
      );
    await loader.load();
  });
  for (final index in [0, 3, 6]) {
    testWidgets('карточка $index передаёт статью и Hero из своей секции', (
      tester,
    ) async {
      final repository = FakeNewsRepository(newsFixture(9));
      await pumpHome(tester, repository);
      final tile = find.byWidgetPredicate(
        (widget) =>
            widget is ArticleTile &&
            identical(widget.article, repository.articles[index]),
      );
      final hero = tester.widget<Hero>(
        find.descendant(of: tile, matching: find.byType(Hero)),
      );
      await tester.tapAt(tester.getTopLeft(tile) + const Offset(40, 40));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();

      final detail = tester.widget<NewsDetailPage>(find.byType(NewsDetailPage));
      expect(identical(detail.article, repository.articles[index]), isTrue);
      expect(detail.heroTag, hero.tag);
      expect(repository.requests, 1);

      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(repository.requests, 1);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('избранное не открывает детали, возврат сохраняет поиск', (
    tester,
  ) async {
    final repository = FakeNewsRepository(newsFixture(9));
    await pumpHome(tester, repository);
    await tester.enterText(find.byType(TextField), 'Article 0');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('В избранное'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsDetailPage), findsNothing);

    final tile = find.byType(ArticleTile);
    await tester.tapAt(tester.getTopLeft(tile) + const Offset(40, 40));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Article 0',
    );
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
    expect(repository.requests, 1);
  });

  testWidgets('повторяющиеся статьи имеют разные теги Hero', (tester) async {
    await pumpHome(tester, FakeNewsRepository(List.filled(9, _article)));
    final heroes = tester.widgetList<Hero>(find.byType(Hero));
    expect(heroes.map((hero) => hero.tag).toSet().length, heroes.length);
    final tile = find.byType(ArticleTile).first;
    await tester.tapAt(tester.getTopLeft(tile) + const Offset(40, 40));
    await tester.pumpAndSettle();
    expect(find.byType(NewsDetailPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('показывает данные статьи и раскрывает весь полученный текст', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: NewsDetailPage(article: _article, heroTag: 'detail'),
      ),
    );
    await tester.pumpAndSettle();
    for (final text in [
      'Becoming',
      'Michelle Obama',
      'example.com',
      '2018',
      'Nov 13',
      '14:48',
      'UTC',
      _article.description,
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    final content = find.text(_article.content);
    expect(content, findsNothing);
    expect(
      tester
          .getSize(find.byKey(const ValueKey('expand-article-content')))
          .height,
      lessThanOrEqualTo(78),
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('expand-article-content')),
    );
    await tester.tap(find.byKey(const ValueKey('expand-article-content')));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(content).maxLines, isNull);
    expect(find.text('LESS'), findsOneWidget);
    await tester.ensureVisible(find.byType(SelectableText));
    expect(
      tester.widget<SelectableText>(find.byType(SelectableText)).data,
      _article.url,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('пустые данные и некорректная дата не ломают экран', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NewsDetailPage(
          heroTag: 'empty',
          article: NewsArticleEntity(
            author: '',
            title: '',
            description: '',
            url: '',
            urlToImage: '',
            publishedAt: 'unknown',
            content: '',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Без заголовка'), findsOneWidget);
    expect(find.text('Автор не указан'), findsOneWidget);
    expect(find.text('unknown'), findsOneWidget);
    expect(find.text('Текст новости отсутствует'), findsOneWidget);
    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    expect(find.byType(SelectableText), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('узкий экран с крупным текстом прокручивается без переполнений', (
    tester,
  ) async {
    await pumpHome(
      tester,
      FakeNewsRepository([_article]),
      size: const Size(320, 568),
      textScale: 2,
    );
    final tile = find.byType(ArticleTile);
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getTopLeft(tile) + const Offset(40, 40));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('expand-article-content')),
    );
    await tester.tap(find.byKey(const ValueKey('expand-article-content')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(SelectableText));
    expect(find.byTooltip('Назад').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
