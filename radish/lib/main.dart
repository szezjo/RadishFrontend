import 'package:flutter/material.dart';
import 'package:radish/pages/home.dart';
import 'package:radish/pages/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => const LoadingPage(title: "Loading Page"),
        "/home": (context) => const MyHomePage(title: 'Home Page'),
      }
    );
  }
}

