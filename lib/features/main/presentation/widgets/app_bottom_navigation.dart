import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavigationItemData(label: 'EXPLORE', icon: _NavigationIcon.explore),
    _NavigationItemData(label: 'EVERYTHING', icon: _NavigationIcon.favorite),
    _NavigationItemData(label: 'PROFILE', icon: _NavigationIcon.menu),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F5F3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(28, 16, 28, 16),
        child: SizedBox(
          height: 58,
          child: Row(
            children: List.generate(_items.length, (index) {
              final isSelected = currentIndex == index;
              return Expanded(
                flex: isSelected ? 2 : 1,
                child: _NavigationItem(
                  data: _items[index],
                  selected: isSelected,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _NavigationItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: data.label,
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BottomNavigationIcon(icon: data.icon),
              if (selected) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    data.label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.25,
                    ),
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

class _BottomNavigationIcon extends StatelessWidget {
  const _BottomNavigationIcon({required this.icon});

  final _NavigationIcon icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 42,
      child: CustomPaint(painter: _NavigationIconPainter(icon)),
    );
  }
}

class _NavigationIconPainter extends CustomPainter {
  const _NavigationIconPainter(this.icon);

  final _NavigationIcon icon;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.65
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (icon) {
      case _NavigationIcon.explore:
        _paintExplore(canvas, paint);
      case _NavigationIcon.favorite:
        _paintFavorite(canvas, paint);
      case _NavigationIcon.menu:
        _paintMenu(canvas, paint);
    }
  }

  void _paintExplore(Canvas canvas, Paint paint) {
    canvas.drawCircle(const Offset(16.5, 15.5), 11.5, paint);
    canvas.drawLine(const Offset(24.5, 24), const Offset(38, 37.5), paint);
    canvas.drawLine(const Offset(11, 11), const Offset(13, 9), paint);
    canvas.drawLine(const Offset(17.5, 7), const Offset(20, 7.5), paint);
  }

  void _paintFavorite(Canvas canvas, Paint paint) {
    final path = Path()
      ..moveTo(21, 36.5)
      ..cubicTo(18, 33.5, 6.5, 25.5, 5.5, 16.5)
      ..cubicTo(4.5, 8.5, 14, 4.5, 21, 12)
      ..cubicTo(28, 4.5, 37.5, 8.5, 36.5, 16.5)
      ..cubicTo(35.5, 25.5, 24, 33.5, 21, 36.5)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawLine(const Offset(29.5, 8.5), const Offset(31, 10), paint);
  }

  void _paintMenu(Canvas canvas, Paint paint) {
    canvas.drawLine(const Offset(9, 10), const Offset(34, 10), paint);
    canvas.drawLine(const Offset(5.5, 21), const Offset(36.5, 21), paint);
    canvas.drawLine(const Offset(5.5, 32), const Offset(34, 32), paint);
  }

  @override
  bool shouldRepaint(_NavigationIconPainter oldDelegate) {
    return oldDelegate.icon != icon;
  }
}

class _NavigationItemData {
  const _NavigationItemData({required this.label, required this.icon});

  final String label;
  final _NavigationIcon icon;
}

enum _NavigationIcon { explore, favorite, menu }
