import 'package:dd_app/screens/blog.dart';
import 'package:dd_app/screens/home_screen/notifications_screen.dart';
import 'package:dd_app/screens/home_screen/open_qr_scanner.dart';
import 'package:dd_app/screens/profile_screen/change_password_screen.dart';
import 'package:dd_app/screens/search/search_bar_page.dart';
import 'package:dd_app/screens/payment_screen.dart';
import 'package:dd_app/screens/view_all_vendors.dart';
import 'package:dd_app/screens/profile_screen/profile.dart';
import 'package:dd_app/screens/category_page.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/screens/authentication/login_screen.dart';
import 'package:dd_app/screens/authentication/enter_phone.dart';
import 'package:dd_app/screens/authentication/otp_code.dart';
import 'package:dd_app/screens/authentication/registration_details.dart';
import 'package:dd_app/screens/authentication/login_register.dart';
import 'package:dd_app/screens/about_us.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/screens/scanned_data_screen.dart';
import 'package:dd_app/screens/discount_history.dart';
import 'package:dd_app/utilities/constants.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dd_app/screens/opening_screen.dart';
import 'package:dd_app/screens/authentication/reset_password.dart';
import 'package:dd_app/screens/payment_history.dart';
import 'package:dd_app/screens/profile_screen/profile_edit_screen.dart';

import 'utilities/payment_webview_screen.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFCFEFF),
        primaryColor: kPrimaryColor,
      ),
      //home: Profile(),
      initialRoute: OpeningScreen.id,
      routes: {
        OpeningScreen.id: (context) => OpeningScreen(),
        //ShareYourLocation.id: (context) => ShareYourLocation(),
        LoginRegister.id: (context) => LoginRegister(),
        LoginScreen.id: (context) => LoginScreen(),
        EnterPhone.id: (context) => EnterPhone(),
        OTPCode.id: (context) => OTPCode(),
        RegisterUserDetails.id: (context) => RegisterUserDetails(),
        ResetPassword.id: (context) => ResetPassword(),
        HomePage.id: (context) => HomePage(),
        SearchBarPage.id: (context) => SearchBarPage(),
        OpenQRScanner.id: (context) => OpenQRScanner(),
        ScannedData.id: (context) => ScannedData(),
        ViewAllVendors.id: (context) => ViewAllVendors(),
        CategoryPage.id: (context) => CategoryPage(),
        Profile.id: (context) => Profile(),
        ProfileEdit.id: (context) => ProfileEdit(),
        Blog.id: (context) => Blog(),
        Payment.id: (context) => Payment(),
        DiscountHistory.id: (context) => DiscountHistory(),
        PaymentHistory.id: (context) => PaymentHistory(),
        AboutUs.id: (context) => AboutUs(),
        NotificationScreen.id: (context) => NotificationScreen(),
        PaymentWebview.id: (context) => PaymentWebview(),
        ChangePasswordScreen.id: (context) => ChangePasswordScreen(),
      },
    );
  }
}

//To build apk without errors, run -> flutter build apk --no-tree-shake-icons
//for play store run ->
// Get SHA -1 Key
//keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
