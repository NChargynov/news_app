import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/presentation/widgets/news_image.dart';

@RoutePage()
class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.article});

  final NewsEntity article;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final panelTop = math.max(60.0, topInset + 24);

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: Stack(
        children: [
          Positioned(
            top: panelTop - 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: panelTop,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 42, 30, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _Cover(article: article),
                              const SizedBox(height: 25),
                              Text(
                                article.title.isEmpty
                                    ? 'Untitled'
                                    : article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                article.author.isEmpty
                                    ? 'Unknown author'
                                    : article.author,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFE0E0E0),
                              ),
                              const SizedBox(height: 17),
                              _Metadata(article: article),
                              const SizedBox(height: 31),
                              const Text(
                                'Synopsis',
                                style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                _synopsis,
                                style: const TextStyle(
                                  color: Color(0xFF4B4B4B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.52,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 38),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => context.router.maybePop(),
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                    constraints: const BoxConstraints(
                                      minWidth: 48,
                                      minHeight: 48,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Color(0xFF111111),
                                      size: 30,
                                    ),
                                  ),
                                  const Spacer(),
                                  FilledButton.icon(
                                    onPressed: () => context.router.pop(true),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: const Color(0xFF232323),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 13,
                                      ),
                                    ),
                                    icon: const Icon(Icons.check_rounded),
                                    label: const Text('Прочитано'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _synopsis {
    final parts = <String>[
      if (article.description.trim().isNotEmpty) article.description.trim(),
      if (article.content.trim().isNotEmpty &&
          article.content.trim() != article.description.trim())
        article.content.trim(),
    ];
    return parts.isEmpty ? 'No description available.' : parts.join('\n\n');
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.article});

  final NewsEntity article;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: article,
        child: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: NewsImage(article: article, iconSize: 34, cacheHeight: 300),
          ),
        ),
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.article});

  final NewsEntity article;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final publishedAt = article.publishedAt.toLocal();
    final author = article.author.trim().isEmpty
        ? 'Unknown'
        : article.author.trim();
    final contentLength = article.content.trim().length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _MetadataItem(
            label: 'Author',
            value: author,
            valueSize: 13,
            maxLines: 3,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 3,
          child: _MetadataItem(
            label: 'Published',
            value: publishedAt.year.toString(),
            secondary: '${_months[publishedAt.month - 1]} ${publishedAt.day}',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 3,
          child: _MetadataItem(
            label: 'Length',
            value: contentLength.toString(),
            secondary: 'characters',
          ),
        ),
      ],
    );
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.label,
    required this.value,
    this.secondary,
    this.valueSize = 23,
    this.maxLines = 1,
  });

  final String label;
  final String value;
  final String? secondary;
  final double valueSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAAAAAA),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: valueSize,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        if (secondary != null) ...[
          const SizedBox(height: 7),
          Text(
            secondary!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF303030),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
