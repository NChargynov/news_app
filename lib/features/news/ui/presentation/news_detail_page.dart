import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/entity/news_article_entity.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';
import 'package:news_app/features/news/ui/presentation/widgets/news_article_image.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({
    super.key,
    required this.article,
    required this.heroTag,
  });

  final NewsArticleEntity article;
  final Object heroTag;

  static Route<void> route({
    required NewsArticleEntity article,
    required Object heroTag,
  }) => PageRouteBuilder<void>(
    settings: RouteSettings(name: '/news/detail', arguments: article),
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) =>
        NewsDetailPage(article: article, heroTag: heroTag),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(article.publishedAt);
    final source = Uri.tryParse(article.url)?.host ?? '';
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Semantics(
                            image: true,
                            label: article.title,
                            child: SizedBox(
                              width: 200,
                              height: 300,
                              child: Hero(
                                tag: heroTag,
                                child: NewsArticleImage(
                                  url: article.urlToImage,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          article.title.isEmpty
                              ? 'Без заголовка'
                              : article.title,
                          textAlign: TextAlign.center,
                          style: NewsHomeStyle.greeting.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article.author.isEmpty
                              ? 'Автор не указан'
                              : article.author,
                          textAlign: TextAlign.center,
                          style: _DetailStyle.author,
                        ),
                        const SizedBox(height: 30),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: NewsHomeStyle.divider,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: _Metadata(
                                label: 'Source',
                                value: source.isEmpty ? '—' : source,
                                compact: true,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: _Metadata(
                                label: 'Published',
                                value:
                                    date?.year.toString() ??
                                    (article.publishedAt.isEmpty
                                        ? '—'
                                        : article.publishedAt),
                                detail: date == null
                                    ? null
                                    : localizations.formatShortMonthDay(date),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: _Metadata(
                                label: 'Time',
                                value: date == null
                                    ? '—'
                                    : localizations.formatTimeOfDay(
                                        TimeOfDay.fromDateTime(date),
                                        alwaysUse24HourFormat: true,
                                      ),
                                detail: date == null
                                    ? null
                                    : date.isUtc
                                    ? 'UTC'
                                    : 'Local',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Text('Synopsis', style: _DetailStyle.label),
                        const SizedBox(height: 20),
                        if (article.description.isNotEmpty)
                          Text(article.description, style: _DetailStyle.body),
                        if (article.description.isNotEmpty &&
                            article.content.isNotEmpty)
                          const SizedBox(height: 26),
                        if (article.content.isNotEmpty)
                          _ArticleContent(content: article.content),
                        if (article.description.isEmpty &&
                            article.content.isEmpty)
                          const Text(
                            'Текст новости отсутствует',
                            style: _DetailStyle.body,
                          ),
                        if (article.url.isNotEmpty) ...[
                          const SizedBox(height: 26),
                          const Text(
                            'Original article',
                            style: _DetailStyle.label,
                          ),
                          const SizedBox(height: 10),
                          SelectableText(article.url, style: _DetailStyle.body),
                        ],
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 22, 26),
                    child: IconButton(
                      tooltip: 'Назад',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const CustomPaint(
                        size: Size(30, 18),
                        painter: _BackArrowPainter(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class _DetailStyle {
  static const author = TextStyle(
    fontFamily: 'Montserrat',
    letterSpacing: 0,
    fontSize: 20,
    fontWeight: FontWeight.w300,
    height: 25 / 20,
    color: Colors.black,
  );
  static const label = TextStyle(
    fontFamily: 'Montserrat',
    letterSpacing: 0,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 15 / 12,
    color: NewsHomeStyle.muted,
  );
  static const body = TextStyle(
    fontFamily: 'Montserrat',
    letterSpacing: 0,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 26 / 16,
    color: NewsHomeStyle.text,
  );
}

class _Metadata extends StatelessWidget {
  const _Metadata({
    required this.label,
    required this.value,
    this.detail,
    this.compact = false,
  });

  final String label;
  final String value;
  final String? detail;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _DetailStyle.label),
        const SizedBox(height: 8),
        Text(
          value,
          style: NewsHomeStyle.sectionTitle.copyWith(
            fontSize: compact ? 14 : 26,
            height: compact ? 17 / 14 : 32 / 26,
          ),
        ),
        if (detail != null) ...[
          const SizedBox(height: 4),
          Text(
            detail!,
            style: _DetailStyle.label.copyWith(color: Colors.black),
          ),
        ],
      ],
    );
  }
}

class _ArticleContent extends StatefulWidget {
  const _ArticleContent({required this.content});

  final String content;

  @override
  State<_ArticleContent> createState() => _ArticleContentState();
}

class _ArticleContentState extends State<_ArticleContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.content, style: _DetailStyle.body),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          maxLines: 3,
        )..layout(maxWidth: constraints.maxWidth);
        final canExpand = painter.didExceedMaxLines;
        painter.dispose();

        if (canExpand && !_expanded) {
          final characters = widget.content.characters.toList();
          var low = 0;
          var high = characters.length;
          TextSpan collapsedSpan(int end) => TextSpan(
            style: _DetailStyle.body,
            children: [
              TextSpan(text: characters.take(end).join().trimRight()),
              TextSpan(
                text: '… MORE',
                style: NewsHomeStyle.sectionTitle.copyWith(fontSize: 11),
              ),
            ],
          );

          final measure = TextPainter(
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: 3,
          );
          // Находим границу текста с учётом места для MORE в третьей строке.
          while (low < high) {
            final middle = (low + high + 1) ~/ 2;
            measure.text = collapsedSpan(middle);
            measure.layout(maxWidth: constraints.maxWidth);
            if (measure.didExceedMaxLines) {
              high = middle - 1;
            } else {
              low = middle;
            }
          }
          measure.dispose();

          return Semantics(
            button: true,
            hint: 'Показать весь текст',
            child: GestureDetector(
              key: const ValueKey('expand-article-content'),
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _expanded = true),
              child: Text.rich(collapsedSpan(low)),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.content, style: _DetailStyle.body),
            if (canExpand)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _expanded = false),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle: NewsHomeStyle.sectionTitle.copyWith(
                      fontSize: 11,
                    ),
                  ),
                  child: const Text('LESS'),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BackArrowPainter extends CustomPainter {
  const _BackArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NewsHomeStyle.text
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final middle = size.height / 2;
    canvas.drawPath(
      Path()
        ..moveTo(8, middle - 7)
        ..lineTo(1, middle)
        ..lineTo(8, middle + 7)
        ..moveTo(1, middle)
        ..lineTo(size.width, middle),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BackArrowPainter oldDelegate) => false;
}
