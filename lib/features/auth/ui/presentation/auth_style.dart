import 'package:flutter/material.dart';

abstract final class AuthStyle {
  static const text = Color(0xFF232323);
  static const muted = Color(0xFF9F9F9F);
  static const field = Color(0xFFEDEDED);
  static const divider = Color(0xFFDCDCDC);
  static const error = Color(0xFFB3261E);

  static const title = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 37 / 30,
    letterSpacing: 0,
    color: text,
  );
  static const body = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    color: text,
  );
  static const label = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
    color: text,
  );
  static const input = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    color: text,
  );
}
