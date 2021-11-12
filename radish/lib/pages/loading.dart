import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is a loading screen.',
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                  },
                icon: const Icon(Icons.home),
                label: const Text("Go Home"))
          ],
        ),
      ),
    );
  }
}