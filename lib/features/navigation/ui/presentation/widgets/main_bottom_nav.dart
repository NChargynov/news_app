import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Компоненты Figma bottom menu / 1active, 2active и 3active (375 × 100).
class MainBottomNav extends StatelessWidget {
  const MainBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _labels = ['EXPLORE', 'FAVOURITE', 'MENU'];
  static const _semantics = ['Главная', 'Все новости', 'Профиль'];
  static const _icons = ['search', 'favourite', 'menu'];
  static const _positions = [
    [30.0, 220.0, 300.0],
    [35.0, 110.0, 300.0],
    [35.0, 115.0, 217.0],
  ];
  static const _activeWidths = [155.0, 165.0, 128.0];

  static double heightFor(BuildContext context) =>
      100 + math.max(0, MediaQuery.paddingOf(context).bottom - 25);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: ColoredBox(
          color: const Color(0xBFF4F4F4),
          child: SizedBox(
            height: heightFor(context),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scale = constraints.maxWidth / 375;
                return Stack(
                  children: [
                    for (var index = 0; index < 3; index++)
                      Positioned(
                        left: _positions[selectedIndex][index] * scale,
                        top: 25,
                        width:
                            (selectedIndex == index
                                ? _activeWidths[index]
                                : 60) *
                            scale,
                        height: 50,
                        child: Semantics(
                          button: true,
                          selected: selectedIndex == index,
                          label: _semantics[index],
                          onTap: () => onSelected(index),
                          child: Tooltip(
                            message: _semantics[index],
                            excludeFromSemantics: true,
                            child: ExcludeSemantics(
                              child: Material(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => onSelected(index),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: selectedIndex == index
                                          ? 20
                                          : 15,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/icons/bottom_nav/${_icons[index]}.png',
                                            width: 30,
                                            height: 30,
                                            filterQuality: FilterQuality.high,
                                          ),
                                          if (selectedIndex == index) ...[
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              width: _activeWidths[index] - 85,
                                              child: Text(
                                                _labels[index],
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  fontVariations: [
                                                    ui.FontVariation(
                                                      'wght',
                                                      600,
                                                    ),
                                                  ],
                                                  height: 15 / 12,
                                                  letterSpacing: 0,
                                                  color: Color(0xFF232323),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
