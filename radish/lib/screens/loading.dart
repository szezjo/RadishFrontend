import 'package:flutter/material.dart';
import 'dart:async';
import 'package:radish/screens/home.dart';
import 'package:radish/screens/welcome.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  void setupApp() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushReplacementNamed(context, "/welcome");
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
              'images/loader.gif',
              height: 150,
              width: 150,
            )
            )
        )
    );
  }
}