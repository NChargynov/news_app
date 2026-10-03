import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:news_app/features/news/ui/presentation/widgets/article_tile.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({
    super.key,
    required this.title,
    required this.articles,
    this.highlighted = false,
    this.favorites = const {},
    this.onFavoriteToggle,
  });

  final String title;
  final List<NewsArticleEntity> articles;
  final bool highlighted;
  final Set<NewsArticleEntity> favorites;
  final ValueChanged<NewsArticleEntity>? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final rowHeight = highlighted
        ? 220.0
        : 182 + textScaler.scale(12) * 15 / 12 + textScaler.scale(11) * 13 / 11;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: NewsHomeStyle.horizontalPadding,
          ),
          child: Container(
            height: math.max(60, textScaler.scale(14) * 17 / 14 + 40),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: NewsHomeStyle.divider)),
            ),
            child: Semantics(
              header: true,
              child: Text(title, style: NewsHomeStyle.sectionTitle),
            ),
          ),
        ),
        SizedBox(
          height: rowHeight,
          child: articles.isEmpty
              ? Center(
                  child: Text(
                    'Пока нет новостей',
                    style: NewsHomeStyle.search.copyWith(
                      color: NewsHomeStyle.muted,
                    ),
                  ),
                )
              : ListView.separated(
                  key: PageStorageKey('news-section-$title'),
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.symmetric(
                    horizontal: NewsHomeStyle.horizontalPadding,
                  ),
                  itemCount: articles.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 30),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ArticleTile(
                      article: article,
                      highlighted: highlighted,
                      isFavorite: favorites.contains(article),
                      onFavoriteToggle: onFavoriteToggle == null
                          ? null
                          : () => onFavoriteToggle!(article),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
