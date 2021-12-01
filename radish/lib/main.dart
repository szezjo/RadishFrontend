import 'package:flutter/material.dart';
import 'package:radish/screens/home.dart';
import 'package:radish/screens/listen.dart';
import 'package:radish/screens/loading.dart';
import 'package:radish/screens/station_list.dart';
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
      onGenerateRoute: (settings) {
        dynamic page;
        switch(settings.name) {
          case "/welcome": {  page = const WelcomePage(); }
          break;
          case "/login": {  page = const LoginPage(); }
          break;
          case "/signup": {  page = const SignUpPage(); }
          break;
          case "/home": {  page = const MyHomePage(title: 'Home Page'); }
          break;
          case "/listen": {  page = const ListenPage(); }
          break;
          case "/stations": {  page = const StationListPage(); }
          break;
          default: { page = const LoadingPage(); }
          break;
        }
        return PageRouteBuilder(
            settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
            pageBuilder: (c, a1, a2) => page,
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}

