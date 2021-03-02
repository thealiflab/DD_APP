import 'package:dd_app/screens/hotel_only.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/screens/opening_screen.dart';
import 'package:dd_app/screens/share_your_location.dart';
import 'package:dd_app/screens/enter_phone.dart';
import 'package:dd_app/screens/verification_code.dart';
import 'package:dd_app/screens/registration_new_user.dart';
import 'package:dd_app/screens/deal_swiper.dart';
import 'package:dd_app/screens/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFCFEFF),
        primaryColor: Color(0xFF24b5c4),
      ),
      home: HomePage(),
      //O
      //S
      //E
      //V
      //R
      //H
      // initialRoute: ShareYourLocation.id,
      // routes: {
      //   OpeningScreen.id: (context) => OpeningScreen(),
      // },
    );
  }
}
