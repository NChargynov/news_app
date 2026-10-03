import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:news_app/features/news/ui/presentation/news_home_style.dart';

class NewsHeader extends StatelessWidget {
  const NewsHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        NewsHomeStyle.horizontalPadding,
        math.max(60, MediaQuery.paddingOf(context).top + 16),
        NewsHomeStyle.horizontalPadding,
        46,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: math.max(50, textScaler.scale(14) + 30),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => FocusScope.of(context).unfocus(),
              style: NewsHomeStyle.search,
              cursorColor: NewsHomeStyle.text,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search here...',
                hintStyle: NewsHomeStyle.search.copyWith(
                  color: NewsHomeStyle.muted,
                ),
                filled: true,
                fillColor: NewsHomeStyle.searchBackground,
                isDense: true,
                contentPadding: const EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                suffixIconConstraints: BoxConstraints.tightFor(
                  width: 64,
                  height: math.max(50, textScaler.scale(14) + 30),
                ),
                suffixIcon: searchController.text.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomPaint(painter: _SearchIconPainter()),
                      )
                    : IconButton(
                        tooltip: 'Очистить поиск',
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: NewsHomeStyle.muted,
                        ),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: 92),
          const Text('Hi Jorge,', style: NewsHomeStyle.greeting),
          const SizedBox(height: 4),
          const Text(
            'Let’s find something new...',
            style: NewsHomeStyle.subtitle,
          ),
        ],
      ),
    );
  }
}

/// Контурная лупа в стиле иконки из макета, без дополнительной зависимости.
class _SearchIconPainter extends CustomPainter {
  const _SearchIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(0, (size.height - 24) / 2);
    final paint = Paint()
      ..color = NewsHomeStyle.muted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawCircle(const Offset(9, 9), 7.5, paint);
    canvas.drawArc(
      const Rect.fromLTWH(4, 4, 10, 10),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(15, 13)
        ..lineTo(22.5, 20.5)
        ..quadraticBezierTo(24, 22, 22, 23)
        ..quadraticBezierTo(21, 24, 19.5, 22.5)
        ..lineTo(12.5, 15.5)
        ..moveTo(16, 17)
        ..lineTo(18, 15),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SearchIconPainter oldDelegate) => false;
}
