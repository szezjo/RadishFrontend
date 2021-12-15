import 'package:flutter/material.dart';
import 'package:radish/screens/catalogue.dart';
import 'package:radish/screens/following.dart';
import 'package:radish/screens/home.dart';
import 'package:radish/screens/listen.dart';
import 'package:radish/screens/loading.dart';
import 'package:radish/screens/song_list.dart';
import 'package:radish/screens/station.dart';
import 'package:radish/screens/station_list.dart';
import 'package:radish/screens/welcome.dart';
import 'package:radish/screens/login.dart';
import 'package:radish/screens/signup.dart';
import 'package:radish/screens/currently_playing.dart';
import 'package:radish/screens/feed.dart';
import 'package:radish/theme/theme_config.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Radish());
  init();
}

Future<void> init() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setBool('radioInit', false);
  storage.setString('currentUrl', '');
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
          case "/home": {  page = const MainScreen(); }
          break;
          case "/listen": {  page = const ListenPage(); }
          break;
          case "/stations": {  page = const StationListPage(); }
          break;
          case "/station": {  page = const StationPage(); }
          break;
          case "/player": {  page = const CurrentlyPlaying(); }
          break;
          case "/catalogue": {  page = const CataloguePage(); }
          break;
          case "/feed": {  page = const FeedPage(); }
          break;
          case "/recently": {  page = const SongListPage(); }
          break;
          case "/discoveries": {  page = const SongListPage(); }
          break;
          case "/following": {  page = const FollowingPage(); }
          break;
          default: { page = const LoadingPage(); }
          break;
        }
        return PageRouteBuilder(
          settings:
              settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
          pageBuilder: (c, a1, a2) => page,
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}
