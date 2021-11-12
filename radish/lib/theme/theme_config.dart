import 'package:flutter/material.dart';

class ThemeConfig {
  static Color darkPrimary = const Color(0xFFF24E1E);
  static Color darkNav = const Color(0xFF272727);
  static Color darkSecondary = const Color(0xFF171717);
  static Color darkAccent = const Color(0xFFF24E1E);
  static Color darkBG = const Color(0xFF202020);
  static Color darkTextPrimary = const Color(0xFFFFFFFF);
  static Color darkTextSecondary = const Color(0xFFC4C4C4);

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
    fontFamily: 'DM Sans',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, color: darkTextPrimary),
      headline2: TextStyle(fontSize: 50.0, color: darkTextPrimary),
      headline3: TextStyle(fontSize: 36.0, color: darkTextPrimary),
      headline4: TextStyle(fontSize: 24.0, color: darkTextPrimary),
      headline5: TextStyle(fontSize: 20.0, color: darkTextPrimary),
      headline6: TextStyle(fontSize: 16.0, color: darkTextPrimary),
      subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: darkTextSecondary),
      subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkTextSecondary),
      bodyText1: TextStyle(fontSize: 16.0, color: darkTextPrimary),
      bodyText2: TextStyle(fontSize: 14.0, color: darkTextPrimary),
      button: TextStyle(fontSize: 14.0, color: darkTextPrimary),
      caption: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: darkTextPrimary),
      overline: TextStyle(fontSize: 14.0, color: darkTextPrimary),
    )
  );
}