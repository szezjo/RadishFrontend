import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:radish/screens/listen.dart';
import 'package:radish/screens/currently_playing.dart';
import 'package:radish/screens/feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool?> isRadioInit() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    bool? isInit = storage.getBool('radioInit');
    return isInit;
  }

  final List<Widget> _widgetOptions = const <Widget>[
    ListenPage(),
    FeedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.radio, color: Colors.grey),
                label: 'Listen',
                activeIcon: Icon(MdiIcons.radio, color: Colors.redAccent)),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.accountCircle, color: Colors.grey),
                label: 'Profile',
                activeIcon:
                    Icon(MdiIcons.accountCircle, color: Colors.redAccent))
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            isRadioInit().then((value) {
              if (value == true) {
                Navigator.pushNamed(context, "/player");
              }
            });
          },
          child: Icon(MdiIcons.headphones, color: Colors.white),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
