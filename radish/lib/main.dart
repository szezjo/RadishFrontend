import 'package:flutter/material.dart';
import 'package:radish/pages/home.dart';
import 'package:radish/pages/loading.dart';
import 'package:radish/pages/welcome.dart';
import 'package:radish/pages/login.dart';
import 'package:radish/pages/signup.dart';
import 'package:radish/pages/spotify_auth.dart';
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
      initialRoute: "/home",
      routes: {
        "/": (context) => LoadingPage(),
        "/welcome": (context) => const WelcomePage(),
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignUpPage(),
        "/home": (context) => const SpotifyAuthPage(title: 'Home Page'),
      }
    );
  }
}

