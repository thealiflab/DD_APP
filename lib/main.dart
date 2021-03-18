import 'package:dd_app/screens/air_only.dart';
import 'package:dd_app/screens/bus_only.dart';
import 'package:dd_app/screens/helicopter_only.dart';
import 'package:dd_app/screens/hotel_only.dart';
import 'package:dd_app/screens/login_screen.dart';
import 'package:dd_app/screens/profile_screen/profile.dart';
import 'package:dd_app/screens/restaurant_only.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/screens/share_your_location.dart';
import 'package:dd_app/screens/enter_phone.dart';
import 'package:dd_app/screens/verification_code.dart';
import 'package:dd_app/screens/registration_new_user.dart';
import 'package:dd_app/screens/login_register.dart';
import 'file:///D:/PROJECTS/AndroidStudioProjects/dd_app/lib/screens/home_screen/home_page.dart';
import 'package:dd_app/screens/about_us.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFCFEFF),
        primaryColor: Color(0xFF24b5c4),
      ),
      //home: Profile(),
      initialRoute: ShareYourLocation.id,
      routes: {
        //OpeningScreen.id: (context) => OpeningScreen(),
        ShareYourLocation.id: (context) => ShareYourLocation(),
        LoginRegister.id: (context) => LoginRegister(),
        LoginScreen.id: (context) => LoginScreen(),
        EnterPhone.id: (context) => EnterPhone(),
        VerificationCode.id: (context) => VerificationCode(),
        RegistrationNewUser.id: (context) => RegistrationNewUser(),
        HomePage.id: (context) => HomePage(),
        HotelOnly.id: (context) => HotelOnly(),
        RestaurantOnly.id: (context) => RestaurantOnly(),
        BusOnly.id: (context) => BusOnly(),
        AirOnly.id: (context) => AirOnly(),
        HelicopterOnly.id: (context) => HelicopterOnly(),
        Profile.id: (context) => Profile(),
        AboutUs.id: (context) => AboutUs(),
      },
    );
  }
}
