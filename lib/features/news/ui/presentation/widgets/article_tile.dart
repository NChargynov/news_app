import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    super.key,
    required this.article,
    this.highlighted = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final NewsArticleEntity article;
  final bool highlighted;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final width = highlighted ? 140.0 : 100.0;
    final height = highlighted ? 220.0 : 160.0;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: '${article.title}, ${article.author}',
            image: true,
            child: Container(
              width: width,
              height: height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (article.urlToImage.isEmpty)
                      const _ImagePlaceholder()
                    else
                      Image.network(
                        article.urlToImage,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                        errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                        frameBuilder: (context, child, frame, synchronous) =>
                            synchronous || frame != null
                            ? child
                            : const _ImagePlaceholder(),
                      ),
                    if (highlighted && onFavoriteToggle != null)
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: IconButton(
                          tooltip: isFavorite
                              ? 'Убрать из избранного'
                              : 'В избранное',
                          isSelected: isFavorite,
                          onPressed: onFavoriteToggle,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 24,
                            shadows: const [
                              Shadow(color: Colors.black38, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!highlighted) ...[
            const SizedBox(height: 15),
            Text(
              article.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NewsHomeStyle.articleTitle,
            ),
            const SizedBox(height: 5),
            Text(
              article.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NewsHomeStyle.author,
            ),
          ],
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: NewsHomeStyle.searchBackground,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: NewsHomeStyle.muted,
          size: 28,
        ),
      ),
    );
  }
}
