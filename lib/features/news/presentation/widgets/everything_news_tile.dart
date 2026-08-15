import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/presentation/widgets/news_image.dart';

class EverythingNewsTile extends StatelessWidget {
  const EverythingNewsTile({
    super.key,
    required this.article,
    required this.onTap,
    this.featured = false,
    this.showFavorite = false,
  });

  final NewsEntity article;
  final VoidCallback onTap;
  final bool featured;
  final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    final width = featured ? 140.0 : 100.0;
    final imageHeight = featured ? 220.0 : 160.0;

    return Semantics(
      button: true,
      label: article.title,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: article,
                child: Container(
                  width: width,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x30000000),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        NewsImage(article: article, cacheHeight: imageHeight),
                        if (showFavorite)
                          const Positioned(
                            left: 10,
                            bottom: 10,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!featured) ...[
                const SizedBox(height: 10),
                Text(
                  article.title.isEmpty ? 'Untitled' : article.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF151515),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  article.author.isEmpty ? 'Unknown author' : article.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF8F8F8F),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
