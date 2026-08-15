import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/presentation/widgets/everything_news_tile.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({
    super.key,
    required this.title,
    required this.articles,
    required this.onArticleTap,
    this.featured = false,
  });

  final String title;
  final List<NewsEntity> articles;
  final ValueChanged<NewsEntity> onArticleTap;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final listHeight = featured ? 220.0 : 200.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, thickness: 1, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 17),
        SizedBox(
          height: listHeight,
          child: articles.isEmpty
              ? const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'No news found',
                    style: TextStyle(color: Color(0xFF8F8F8F), fontSize: 12),
                  ),
                )
              : ListView.separated(
                  key: PageStorageKey(title),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemCount: articles.length,
                  separatorBuilder: (_, _) =>
                      SizedBox(width: featured ? 24 : 30),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return EverythingNewsTile(
                      article: article,
                      featured: featured,
                      showFavorite: featured && index == 0,
                      onTap: () => onArticleTap(article),
                    );
                  },
                ),
        ),
        const SizedBox(height: 34),
      ],
    );
  }
}
