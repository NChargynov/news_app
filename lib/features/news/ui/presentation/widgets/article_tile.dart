import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:news_app/features/news/ui/presentation/widgets/news_article_image.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    super.key,
    required this.article,
    this.highlighted = false,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.heroTag,
    this.onTap,
  });

  final NewsArticleEntity article;
  final bool highlighted;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final Object? heroTag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final width = highlighted ? 140.0 : 100.0;
    final height = highlighted ? 220.0 : 160.0;

    final image = NewsArticleImage(url: article.urlToImage);

    return Semantics(
      button: onTap != null,
      label: '${article.title}, ${article.author}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                height: height,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    if (heroTag == null)
                      image
                    else
                      Hero(tag: heroTag!, child: image),
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
        ),
      ),
    );
  }
}
