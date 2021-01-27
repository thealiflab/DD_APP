import 'package:flutter/material.dart';
import 'package:dd_app/screens/opening_screen.dart';
import 'package:dd_app/screens/share_your_location.dart';
import 'package:dd_app/screens/enter_phone.dart';
import 'package:dd_app/screens/verification_code.dart';
import 'package:dd_app/screens/registration_new_user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFCFEFF),
      ),
      home: RegistrationNewUser(),
      // initialRoute: ShareYourLocation.id,
      // routes: {
      //   OpeningScreen.id: (context) => OpeningScreen(),
      // },
    );
  }
}
