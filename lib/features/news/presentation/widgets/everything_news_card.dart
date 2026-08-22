import 'package:flutter/material.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/presentation/widgets/news_image.dart';

class EverythingNewsCard extends StatelessWidget {
  const EverythingNewsCard({super.key, required this.article});

  final NewsEntity article;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: article.title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEAEAEA)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 210,
                child: NewsImage(article: article, cacheHeight: 210),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NewsMetadata(article: article),
                    const SizedBox(height: 14),
                    Text(
                      _valueOrFallback(article.title, 'Без заголовка'),
                      style: const TextStyle(
                        color: Color(0xFF202020),
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.25,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _NewsTextSection(
                      label: 'Описание',
                      value: _valueOrFallback(
                        article.description,
                        'Описание отсутствует',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _NewsTextSection(
                      label: 'Содержание',
                      value: _valueOrFallback(
                        article.content,
                        'Содержание отсутствует',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.link_rounded,
                          size: 18,
                          color: Color(0xFF777777),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _valueOrFallback(article.url, 'Ссылка отсутствует'),
                            style: const TextStyle(
                              color: Color(0xFF777777),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _valueOrFallback(String value, String fallback) {
    final normalizedValue = value.trim();
    return normalizedValue.isEmpty ? fallback : normalizedValue;
  }
}

class _NewsMetadata extends StatelessWidget {
  const _NewsMetadata({required this.article});

  final NewsEntity article;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFFF0E9FF),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 17,
                  color: Color(0xFF7D42C8),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  article.author.trim().isEmpty
                      ? 'Автор не указан'
                      : article.author.trim(),
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Text(
              _formatDate(article.publishedAt),
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$day.$month.${localDate.year} · $hour:$minute';
  }
}

class _NewsTextSection extends StatelessWidget {
  const _NewsTextSection({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF9A9A9A),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4A4A4A),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
