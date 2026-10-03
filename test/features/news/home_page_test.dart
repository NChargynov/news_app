import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';
import 'package:news_app/features/news/ui/presentation/widgets/article_tile.dart';
import 'package:news_app/features/news/ui/presentation/widgets/news_section.dart';

import 'support/news_fixture.dart';

Future<void> pumpHome(
  WidgetTester tester,
  FakeNewsRepository repository, {
  Size size = const Size(375, 1360),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: BlocProvider(
        create: (_) =>
            NewsBloc(newsRepository: repository)
              ..add(const GetEverythingEvent()),
        child: const HomePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final loader = FontLoader('Montserrat')
      ..addFont(
        rootBundle.load('assets/fonts/montserrat/Montserrat-Variable.ttf'),
      );
    await loader.load();
  });

  testWidgets('геометрия трёх рядов соответствует фрейму 375 × 1360', (
    tester,
  ) async {
    final repository = FakeNewsRepository(newsFixture(9));
    await pumpHome(tester, repository);

    expect(find.text('Hi Jorge,'), findsOneWidget);
    expect(find.text('Search here...'), findsOneWidget);
    expect(tester.getSize(find.byType(InputDecorator)), const Size(315, 50));
    expect(find.byType(NewsSection), findsNWidgets(3));
    final lists = tester.widgetList<ListView>(find.byType(ListView));
    expect(lists.length, 3);
    expect(
      lists.every((list) => list.scrollDirection == Axis.horizontal),
      isTrue,
    );

    for (final (title, y, size) in [
      ('Article 0', 369.0, const Size(140, 220)),
      ('Article 3', 689.0, const Size(100, 210)),
      ('Article 6', 999.0, const Size(100, 210)),
    ]) {
      final tile = find.byWidgetPredicate(
        (widget) => widget is ArticleTile && widget.article.title == title,
      );
      expect(tester.getTopLeft(tile), Offset(30, y));
      expect(tester.getSize(tile), size);
    }
    expect(repository.requests, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('каждая секция прокручивается независимо', (tester) async {
    await pumpHome(tester, FakeNewsRepository(newsFixture(30)));
    final first = find.byKey(const PageStorageKey('news-section-Trending'));
    final second = find.byKey(
      const PageStorageKey('news-section-New releases'),
    );
    final third = find.byKey(
      const PageStorageKey('news-section-Selected for you'),
    );

    double offset(Finder list) => tester
        .state<ScrollableState>(
          find.descendant(of: list, matching: find.byType(Scrollable)),
        )
        .position
        .pixels;

    await tester.drag(first, const Offset(-240, 0));
    await tester.pumpAndSettle();
    expect(offset(first), greaterThan(0));
    expect(offset(second), 0);
    expect(offset(third), 0);

    await tester.drag(second, const Offset(-180, 0));
    await tester.pumpAndSettle();
    expect(offset(second), greaterThan(0));
    expect(offset(third), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('поиск фильтрует загруженные новости без нового запроса', (
    tester,
  ) async {
    final repository = FakeNewsRepository(newsFixture(9));
    await pumpHome(tester, repository);
    await tester.enterText(find.byType(TextField), 'Article 4');
    await tester.pumpAndSettle();

    expect(find.byType(ArticleTile), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ArticleTile),
        matching: find.text('Article 4'),
      ),
      findsOneWidget,
    );
    expect(repository.requests, 1);

    await tester.enterText(find.byType(TextField), 'нет совпадений');
    await tester.pumpAndSettle();
    expect(find.text('По вашему запросу ничего не найдено'), findsOneWidget);

    await tester.tap(find.byTooltip('Очистить поиск'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsSection), findsNWidgets(3));
    expect(repository.requests, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('отображает пустой ответ', (tester) async {
    await pumpHome(tester, FakeNewsRepository([]));
    expect(find.text('Новостей пока нет'), findsOneWidget);
    expect(find.byType(ArticleTile), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('повторная загрузка после ошибки использует существующий BLoC', (
    tester,
  ) async {
    final repository = FakeNewsRepository(newsFixture(3), shouldFail: true);
    await pumpHome(tester, repository);
    expect(find.text('Новостей нет'), findsOneWidget);
    repository.shouldFail = false;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.byType(NewsSection), findsNWidgets(3));
    expect(repository.requests, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('отметка избранного меняется по нажатию', (tester) async {
    await pumpHome(tester, FakeNewsRepository(newsFixture(3)));
    await tester.tap(find.byTooltip('В избранное'));
    await tester.pump();
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
    await tester.tap(find.byTooltip('Убрать из избранного'));
    await tester.pump();
    expect(find.byTooltip('В избранное'), findsOneWidget);
  });

  for (final count in [1, 2]) {
    testWidgets('короткая выдача из $count статей не дублирует карточки', (
      tester,
    ) async {
      await pumpHome(tester, FakeNewsRepository(newsFixture(count)));
      expect(find.byType(NewsSection), findsNWidgets(3));
      expect(find.byType(ArticleTile), findsNWidgets(count));
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(320, 568), const Size(768, 1024)]) {
    testWidgets('экран $size с увеличенным текстом не переполняется', (
      tester,
    ) async {
      await pumpHome(
        tester,
        FakeNewsRepository(newsFixture(12)),
        size: size,
        textScale: 2,
      );
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
