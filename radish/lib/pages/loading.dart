import 'package:flutter/material.dart';
import 'dart:async';
import 'package:radish/pages/home.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  int _currIconId = 0;
  final List<String> _loadingIcons = [
    'images/loadIcon1.png',
    'images/loadIcon2.png',
    'images/loadIcon3.png',
    'images/loadIcon4.png'
  ];

  void setupApp() async {
    var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currIconId++;
        if (_currIconId >= _loadingIcons.length) {
          _currIconId = 0;
        }
      });
    });
    await Future.delayed(const Duration(seconds: 15));
    timer.cancel();
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (c, a1, a2) => const MyHomePage(title: "Homey!"),
      transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 500),
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
        backgroundColor: Colors.blue[900],
        body: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            child: Center(
              child: Image.asset(
              _loadingIcons[_currIconId],
              height: 150,
              width: 150,
            )
            )
        )
    );
  }
}