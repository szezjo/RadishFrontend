import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        Navigator.pushNamed(context, "/login");
      };
    }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg_login.png"),
                fit: BoxFit.fill
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                          "images/logo_white.png",
                        width: 200,
                      ),
                      const Text(
                          "Listen to your favourite radio stations",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      const Text(
                          "and discover new music!",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.redAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text("Sign up"),
                    onPressed: () => {
                      Navigator.pushNamed(context, "/signup")
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        ),
                      children: <TextSpan>[
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                            text: 'Sign in!',
                            recognizer: _tapGestureRecognizer,
                            style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          )
        ],
      )
    );
  }
}