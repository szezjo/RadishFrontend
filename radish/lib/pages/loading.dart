import 'package:flutter/material.dart';
import 'dart:async';
import 'package:radish/pages/home.dart';
import 'package:radish/pages/welcome.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  void setupApp() async {
    await Future.delayed(const Duration(seconds: 15));
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (c, a1, a2) => const WelcomePage(),
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    );
  }

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            child: Center(
              child: Image.asset(
              'images/loader_rewind.gif',
              height: 150,
              width: 150,
            )
            )
        )
    );
  }
}