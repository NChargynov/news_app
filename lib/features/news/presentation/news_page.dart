import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/presentation/news_detail_page.dart';
import 'package:news_app/features/news/presentation/widgets/news_search_field.dart';
import 'package:news_app/features/news/presentation/widgets/news_section.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NewsBloc>()..add(GetNewsEvent()),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is LoadedNewsState) {
                return _NewsContent(
                  news: state.news,
                  query: _query,
                  onQueryChanged: (value) => setState(() => _query = value),
                  onArticleTap: _openDetails,
                );
              }
              if (state is ErrorNewsState) {
                return _ErrorContent(
                  onRetry: () => context.read<NewsBloc>().add(GetNewsEvent()),
                );
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ),
    );
  }

  void _openDetails(NewsEntity article) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 520),
        reverseTransitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, _, _) => NewsDetailPage(article: article),
        transitionsBuilder: (_, animation, _, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _NewsContent extends StatelessWidget {
  const _NewsContent({
    required this.news,
    required this.query,
    required this.onQueryChanged,
    required this.onArticleTap,
  });

  final List<NewsEntity> news;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<NewsEntity> onArticleTap;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final filteredNews = normalizedQuery.isEmpty
        ? news
        : news.where((article) {
            return article.title.toLowerCase().contains(normalizedQuery) ||
                article.author.toLowerCase().contains(normalizedQuery) ||
                article.description.toLowerCase().contains(normalizedQuery);
          }).toList();
    final sections = _splitIntoThree(filteredNews);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 25, bottom: 28),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: NewsSearchField(onChanged: onQueryChanged),
        ),
        const SizedBox(height: 73),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Jorge,',
                style: TextStyle(
                  color: Color(0xFF232323),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Let’s find something new...',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 37),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: NewsSection(
            title: 'Trending',
            articles: sections[0],
            featured: true,
            onArticleTap: onArticleTap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: NewsSection(
            title: 'New releases',
            articles: sections[1],
            onArticleTap: onArticleTap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: NewsSection(
            title: 'Selected for you',
            articles: sections[2],
            onArticleTap: onArticleTap,
          ),
        ),
      ],
    );
  }

  List<List<NewsEntity>> _splitIntoThree(List<NewsEntity> articles) {
    final result = List.generate(3, (_) => <NewsEntity>[]);
    final baseLength = articles.length ~/ result.length;
    final remainder = articles.length % result.length;
    var start = 0;

    for (var index = 0; index < result.length; index++) {
      final sectionLength = baseLength + (index < remainder ? 1 : 0);
      final end = start + sectionLength;
      result[index] = articles.sublist(start, end);
      start = end;
    }

    return result;
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Unable to load news',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF232323),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
