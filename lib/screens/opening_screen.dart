import 'dart:async';

import 'package:dd_app/screens/login_register.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dd_app/screens/login_register.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';

String loggedInEmail;

Future userLoggedInOrNot() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  loggedInEmail = sharedPreferences.get('phone');
}

class OpeningScreen extends StatefulWidget {
  static const String id = "openning_screen";

  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  @override
  void initState() {
    userLoggedInOrNot().whenComplete(() async {
      loggedInEmail == null
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginRegister()),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF34d3ae),
            kPrimaryColor,
          ],
        ),
      ),
    );
  }
}
