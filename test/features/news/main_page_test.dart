import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/navigation/ui/presentation/main_page.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/presentation/everything_page.dart';
import 'package:news_app/features/news/ui/presentation/home_page.dart';
import 'package:news_app/features/profile/ui/presentation/profile_page.dart';

import 'support/news_fixture.dart';

Future<void> _pumpMain(WidgetTester tester, NewsRepository repository) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) =>
            NewsBloc(newsRepository: repository)
              ..add(const GetEverythingEvent()),
        child: const MainPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _select(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip(label));
  await tester.pumpAndSettle();
}

class _PendingRepository implements NewsRepository {
  final response = Completer<List<NewsArticleEntity>>();

  @override
  Future<List<NewsArticleEntity>> getEverythingArticles() => response.future;
}

void main() {
  testWidgets(
    'вкладки используют весь ответ и сохраняют поиск без новых запросов',
    (tester) async {
      final repository = FakeNewsRepository(newsFixture(27));
      await _pumpMain(tester, repository);
      expect(find.byType(HomePage), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Article 0');
      await tester.pumpAndSettle();

      await _select(tester, 'Все новости');
      expect(find.byType(EverythingPage), findsOneWidget);
      expect(find.text('Article 1'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Article 26'),
        400,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('Article 26').hitTestable(), findsOneWidget);
      final offset = tester
          .state<ScrollableState>(find.byType(Scrollable))
          .position
          .pixels;

      await _select(tester, 'Профиль');
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      await _select(tester, 'Все новости');
      expect(
        tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
        offset,
      );
      await _select(tester, 'Главная');
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Article 0',
      );
      expect(repository.requests, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('EverythingPage отображает пустую выдачу', (tester) async {
    await _pumpMain(tester, FakeNewsRepository([]));
    await _select(tester, 'Все новости');
    expect(find.text('Новостей пока нет'), findsOneWidget);
  });

  testWidgets('EverythingPage позволяет повторить неудачный запрос', (
    tester,
  ) async {
    final repository = FakeNewsRepository(newsFixture(3), shouldFail: true);
    await _pumpMain(tester, repository);
    await _select(tester, 'Все новости');
    expect(find.text('Новостей нет'), findsOneWidget);
    repository.shouldFail = false;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('Article 0'), findsOneWidget);
    expect(repository.requests, 2);
  });

  testWidgets('EverythingPage показывает загрузку общего запроса', (
    tester,
  ) async {
    final repository = _PendingRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) =>
              NewsBloc(newsRepository: repository)
                ..add(const GetEverythingEvent()),
          child: const MainPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Все новости'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.response.complete(newsFixture(1));
    await tester.pumpAndSettle();
    expect(find.text('Article 0'), findsOneWidget);
  });
}
