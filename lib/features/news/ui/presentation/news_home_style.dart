import 'package:flutter/material.dart';

/// Значения из фрейма Figma «template / 00 Explore» (375 × 1360).
abstract final class NewsHomeStyle {
  static const background = Colors.white;
  static const text = Color(0xFF232323);
  static const muted = Color(0xFF9F9F9F);
  static const divider = Color(0xFFDCDCDC);
  static const searchBackground = Color(0xFFEDEDED);
  static const horizontalPadding = 30.0;

  static const greeting = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 30,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
    height: 37 / 30,
    color: text,
  );

  static const subtitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    height: 20 / 16,
    color: text,
  );

  static const search = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    height: 17 / 14,
    color: text,
  );

  static const sectionTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
    height: 17 / 14,
    color: Colors.black,
  );

  static const articleTitle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    height: 15 / 12,
    color: Colors.black,
  );

  static const author = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    letterSpacing: 0,
    fontWeight: FontWeight.w300,
    height: 13 / 11,
    color: Colors.black,
  );
}
