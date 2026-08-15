import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';

class NewsImage extends StatelessWidget {
  const NewsImage({
    super.key,
    required this.article,
    this.fit = BoxFit.cover,
    this.iconSize = 28,
    this.cacheHeight,
  });

  final NewsEntity article;
  final BoxFit fit;
  final double iconSize;
  final double? cacheHeight;

  @override
  Widget build(BuildContext context) {
    if (article.urlToImage.isEmpty) {
      return _ImagePlaceholder(iconSize: iconSize);
    }

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    return CachedNetworkImage(
      imageUrl: article.urlToImage,
      cacheKey: article.urlToImage,
      fit: fit,
      filterQuality: FilterQuality.medium,
      memCacheHeight: _physicalPixels(cacheHeight, pixelRatio),
      useOldImageOnUrlChange: true,
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => const ColoredBox(color: Color(0xFFE8E8E8)),
      errorWidget: (_, _, _) => _ImagePlaceholder(iconSize: iconSize),
    );
  }

  int? _physicalPixels(double? logicalPixels, double pixelRatio) {
    if (logicalPixels == null) {
      return null;
    }
    return (logicalPixels * pixelRatio).round();
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
