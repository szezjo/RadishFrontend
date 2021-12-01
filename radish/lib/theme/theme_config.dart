import 'package:flutter/material.dart';

class ThemeConfig {
  static Color darkBGPrimary = const Color(0xFF171717); // main bg
  static Color darkBGSecondary = const Color(0xFF202020); // top bar & bg without bar
  static Color darkNavbar = const Color(0xFF272727); // bottom navbar
  static Color darkAccentPrimary = const Color(0xFFF24E1E); // icons, tags...
  static Color darkInactivePrimary = const Color(0xFF818181); // inactive navbar icon primary
  static Color darkInactiveSecondary = const Color(0xFFCCCCCC); // inactive navbar icon secondary
  static Color darkTextPrimary = const Color(0xFFFFFFFF); // text primary
  static Color darkTextSecondary = const Color(0xFFC7C7C7); // text secondary
  static Color darkDivider = const Color(0xFF303030); // dividers in lists
  static Color darkIcons = const Color(0xFFC4C4C4); // icons (like, setting, followers)
  static Color darkAccentSecondary = const Color(0xFF8FC267); // online status...

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
        primary: darkBGSecondary,
        primaryVariant: darkNavbar,
        secondary: darkAccentPrimary,
        secondaryVariant: darkAccentPrimary,
        surface: darkBGSecondary,
        background: darkBGPrimary,
        error: darkAccentPrimary,
        onPrimary: darkAccentPrimary,
        onSecondary: darkAccentPrimary,
        onSurface: darkBGSecondary,
        onBackground: darkBGSecondary,
        onError: darkAccentPrimary,
        brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBGPrimary,
    fontFamily: 'DMSans',
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