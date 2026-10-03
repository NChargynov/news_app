import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/bloc/news_state.dart';
import 'package:news_app/features/news/ui/presentation/models/news_sections.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:news_app/features/news/ui/presentation/news_detail_page.dart';
import 'package:news_app/features/news/ui/presentation/widgets/news_header.dart';
import 'package:news_app/features/news/ui/presentation/widgets/news_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _favorites = <NewsArticleEntity>{};
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewsHomeStyle.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            return CustomScrollView(
              key: const PageStorageKey('news-home'),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: NewsHeader(
                    searchController: _searchController,
                    onSearchChanged: (value) => setState(() => _query = value),
                  ),
                ),
                if (state is NewsSuccess)
                  ..._buildSections(state)
                else
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: state is NewsFailure
                        ? _NewsMessage(
                            message: state.message,
                            onRetry: () => context.read<NewsBloc>().add(
                              const GetEverythingEvent(),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: NewsHomeStyle.text,
                            ),
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openArticle(NewsArticleEntity article, Object heroTag) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context)
        .push(NewsDetailPage.route(article: article, heroTag: heroTag));
  }

  List<Widget> _buildSections(NewsSuccess state) {
    final sections = NewsSections.fromArticles(state.news).matching(_query);
    if (sections.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _NewsMessage(
            message: state.news.isEmpty
                ? 'Новостей пока нет'
                : 'По вашему запросу ничего не найдено',
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: NewsSection(
          title: 'Trending',
          onArticleTap: _openArticle,
          articles: sections.trending,
          highlighted: true,
          favorites: _favorites,
          onFavoriteToggle: (article) => setState(() {
            if (!_favorites.add(article)) _favorites.remove(article);
          }),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 40)),
      SliverToBoxAdapter(
        child: NewsSection(
          title: 'New releases',
          onArticleTap: _openArticle,
          articles: sections.newReleases,
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 40)),
      SliverToBoxAdapter(
        child: NewsSection(
          title: 'Selected for you',
          onArticleTap: _openArticle,
          articles: sections.selectedForYou,
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: math.max(151, MediaQuery.paddingOf(context).bottom + 30),
        ),
      ),
    ];
  }
}

class _NewsMessage extends StatelessWidget {
  const _NewsMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(NewsHomeStyle.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: NewsHomeStyle.search,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(foregroundColor: NewsHomeStyle.text),
              child: const Text('Повторить', style: NewsHomeStyle.sectionTitle),
            ),
          ],
        ],
      ),
    );
  }
}
