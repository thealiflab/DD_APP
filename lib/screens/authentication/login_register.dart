import 'package:dd_app/screens/authentication/enter_phone.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/api/guest_login_api.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:flutter/services.dart';

SharedPreferences localStorage;

class LoginRegister extends StatefulWidget {
  static const String id = "login_register";

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GuestLoginAPI guestLoginAPI;
  bool _isApiCallProcess = false;

  String _gUserPhoto = "";
  String _gUserName = "";
  String _gUserID = "";
  String _gUserEmail = "";

  Future sharedPrefFunc() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    sharedPrefFunc();
    guestLoginAPI = GuestLoginAPI();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //To exit the app when system back button pressed
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit DD Travel App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: kPageBackgroundGradientEffect,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
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
                  ActionButton(
                    buttonColor: Colors.transparent,
                    buttonText: "Registration",
                    onTap: () async {
                      localStorage = await SharedPreferences.getInstance();
                      localStorage.setBool("resetPassword", false);
                      Navigator.pushNamed(
                        context,
                        EnterPhone.id,
                      );
                    },
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ActionButton(
                    buttonColor: Colors.white,
                    buttonText: "Login",
                    onTap: () => Navigator.pushNamed(context, LoginScreen.id),
                    textColor: kPrimaryColor,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Text(
                  //   "Login with :",
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     IconButton(
                  //         icon: FaIcon(
                  //           FontAwesomeIcons.facebookF,
                  //         ),
                  //         onPressed: () {
                  //           print(_gUserName);
                  //         }),
                  //     IconButton(
                  //         icon: FaIcon(FontAwesomeIcons.google),
                  //         onPressed: () {
                  //           _googleSignIn.signIn().then((userData) {
                  //             print(userData);
                  //             setState(() {
                  //               _gUserID = userData.id;
                  //               _gUserEmail = userData.email;
                  //               _gUserName = userData.displayName;
                  //               _gUserPhoto = userData.photoUrl;
                  //             });
                  //           });
                  //         }),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.white),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              50.0,
                            ),
                            side: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                      ),
                      child: Text(
                        "Skip >",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isApiCallProcess = true;
                        });

                        guestLoginAPI.getGData().then((value) {
                          setState(() {
                            _isApiCallProcess = false;
                          });

                          if (value['status'].toString() == "true") {
                            print("Below data is got from guest api");
                            print(value['Customer-ID']);
                            print(value['token']);
                            print(value['AccountType']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBarMessage(
                                "Guest Login Success!",
                                true,
                              ),
                            );
                            //To store data in local storage
                            localStorage.setString(
                                'Customer-ID', value['Customer-ID'].toString());
                            localStorage.setString(
                                'Authorization', value['token'].toString());
                            localStorage.setString('accountType', "Guest");

                            Navigator.pushNamed(
                              context,
                              HomePage.id,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBarMessage(
                                "Guest Login Failed",
                                false,
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
