import 'package:flutter/material.dart';

class ThemeConfig {
  static Color darkPrimary = const Color(0xFFF24E1E);
  static Color darkSecondary = const Color(0xFF171717);
  static Color darkAccent = const Color(0xFFF24E1E);
  static Color darkBG = const Color(0xFF202020);

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
        primary: darkPrimary,
        primaryVariant: darkPrimary,
        secondary: darkSecondary,
        secondaryVariant: darkSecondary,
        surface: darkSecondary,
        background: darkBG,
        error: darkAccent,
        onPrimary: darkAccent,
        onSecondary: darkAccent,
        onSurface: darkAccent,
        onBackground: darkAccent,
        onError: darkAccent,
        brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBG,

  );
}