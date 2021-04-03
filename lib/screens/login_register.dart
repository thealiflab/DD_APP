import 'package:dd_app/screens/enter_phone.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/app_join_button.dart';
import 'package:dd_app/utilities/skip_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

String loggedInEmail;

Future userLoggedInOrNot() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  loggedInEmail = sharedPreferences.get('phone');
}

class LoginRegister extends StatefulWidget {
  static const String id = "login_register";

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: kPageBackgroundGradientEffect,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/ddlogow.png'),
                height: MediaQuery.of(context).size.width * 0.45,
              ),
              Text(
                'DD Travel App',
                style: TextStyle(
                    height: 3,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 70,
              ),
              AppJoinButton(
                buttonColor: Colors.transparent,
                buttonText: "Registration",
                onTap: () => Navigator.pushNamed(context, EnterPhone.id),
                textColor: Colors.white,
              ),
              SizedBox(
                height: 15,
              ),
              AppJoinButton(
                buttonColor: Colors.white,
                buttonText: "Login",
                onTap: () => Navigator.pushNamed(context, LoginScreen.id),
                textColor: kPrimaryColor,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SkipButton(
                  onTap: () => Navigator.pushNamed(context, HomePage.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
