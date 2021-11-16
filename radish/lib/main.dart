import 'package:flutter/material.dart';
import 'package:radish/pages/home.dart';
import 'package:radish/pages/loading.dart';
import 'package:radish/theme/theme_config.dart';

void main() {
  runApp(const Radish());
}

class Radish extends StatelessWidget {
  const Radish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radish',
      theme: ThemeConfig.darkTheme,
      routes: {
        "/": (context) => LoadingPage(),
        "/home": (context) => const MyHomePage(title: 'Home Page'),
      }
    );
  }
}

