import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radish/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  handleClick() async {
    var email = emailController.text;
    var password = passwordController.text;

    final response = await http.post(
      Uri.parse('https://radish-app.herokuapp.com/user/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode != 200) {
      print("${response.statusCode} COULDN'T LOG IN");
      print("${jsonDecode(response.body)}");
      return;
    }

    SharedPreferences storage = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap = jsonDecode(response.body);
    String user = jsonEncode(User.fromJson(userMap));
    storage.setString('userData', user);

    print("LOGGED IN");

    //Navigator.pushReplacementNamed(context, "/listen");
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bg_login.png"), fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "images/logo_white.png",
                      width: 100,
                    ),
                    const SizedBox(height: 50.0),
                    FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: emailController,
                              decoration: kInputDecoration,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              "Password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: kInputDecoration,
                            ),
                          ],
                        )),
                    const SizedBox(height: 20.0),
                    TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.redAccent),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: const Text("Sign in"),
                        onPressed: handleClick),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  final kInputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ));
}
