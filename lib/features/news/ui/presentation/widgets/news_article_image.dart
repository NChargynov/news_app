import 'package:flutter/material.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';

class NewsArticleImage extends StatelessWidget {
  const NewsArticleImage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
        child: url.isEmpty
            ? const _ImagePlaceholder()
            : Image.network(
                url,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                frameBuilder: (context, child, frame, synchronous) =>
                    synchronous || frame != null
                    ? child
                    : const _ImagePlaceholder(),
              ),
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
