import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';

class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    required this.article,
    this.fit = BoxFit.cover,
    this.iconSize = 28,
  });

  final NewsEntity article;
  final BoxFit fit;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (article.urlToImage.isEmpty) {
      return _ImagePlaceholder(iconSize: iconSize);
    }

    return Image.network(
      article.urlToImage,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return const ColoredBox(color: Color(0xFFE8E8E8));
      },
      errorBuilder: (_, _, _) => _ImagePlaceholder(iconSize: iconSize),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.iconSize});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8E8E8),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: iconSize,
          color: const Color(0xFF9A9A9A),
        ),
      ),
    );
  }
}
