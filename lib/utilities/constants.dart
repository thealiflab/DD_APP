import 'package:flutter/material.dart';

//UI Constants
const kPrimaryColor = Color(0xFF24b5c4);
const kLightPrimaryColor = Color(0xFF34d3ae);

//home_screen
const bottomNavigationBarButtonLabelStyle = TextStyle(
  color: kPrimaryColor,
);

//login_screen
const kPageBackgroundGradientEffect = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      kLightPrimaryColor,
      kPrimaryColor,
    ],
  ),
);

const kLoginInputDecoration = InputDecoration(
  counterText: "",
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
    ),
    borderRadius: const BorderRadius.all(
      const Radius.circular(50.0),
    ),
  ),
  filled: true,
  fillColor: Color(0xFFf9f9f9),
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  hintText: "Phone",
);
const String kCredit = "Developed by Alif";

//LoginScreen, EnterPhone, OTPCode, RegistrationDetails
const kCardPadding = EdgeInsets.only(
  left: 10,
  top: 20,
  right: 10,
);

const kFormPadding = EdgeInsets.only(
  top: 58,
  bottom: 10,
);
