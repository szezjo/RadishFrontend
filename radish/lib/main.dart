import 'package:flutter/material.dart';
import 'package:radish/screens/home.dart';
import 'package:radish/screens/loading.dart';
import 'package:radish/screens/welcome.dart';
import 'package:radish/screens/login.dart';
import 'package:radish/screens/signup.dart';
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
      initialRoute: "/login",
      routes: {
        "/": (context) => const LoadingPage(),
        "/welcome": (context) => const WelcomePage(),
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignUpPage(),
        "/home": (context) => const MyHomePage(title: 'Home Page'),
      }
    );
  }
}

