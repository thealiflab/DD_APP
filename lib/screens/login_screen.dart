import 'package:dd_app/api/login_api.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/skip_button.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferences
SharedPreferences localStorage;

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();
  bool _hidePassword = true;
  LoginRequestModel requestModel;
  bool _isApiCallProcess = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future sharedPrefFunc() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    sharedPrefFunc();
    //requestModel object is created for sending data to web-server through api
    requestModel = new LoginRequestModel();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
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
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context)
              .size
              .height, //TODO this for all similar page
          alignment: Alignment.center,
          decoration: kPageBackgroundGradientEffect,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                JoinNowHeading(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 20,
                            right: 10,
                            bottom: 5,
                          ),
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 55,
                                bottom: 10,
                              ),
                              child: Form(
                                key: _globalFormKey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Enter login Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Container(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                        ),
                                        child: TextFormField(
                                          controller: phoneController,
                                          textAlign: TextAlign.center,
                                          decoration: kLoginInputDecoration,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 11,
                                          validator: (input) => input.length <
                                                      11 ||
                                                  input.isEmpty
                                              ? "Phone Number should be valid"
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 30,
                                        ),
                                        child: TextFormField(
                                          controller: passwordController,
                                          textAlign: TextAlign.center,
                                          decoration:
                                              kLoginInputDecoration.copyWith(
                                            hintText: "Password",
                                            suffixIcon: IconButton(
                                              icon: Icon(_hidePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    _hidePassword =
                                                        !_hidePassword;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          obscureText: _hidePassword,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          maxLength: 50,
                                          validator: (input) => input.length <
                                                      6 ||
                                                  input.isEmpty
                                              ? "Password should be at least 6 character long"
                                              : null,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          right: 50,
                          top: 12,
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          right: 50,
                          top: 18,
                          child: Image(
                            image: AssetImage('assets/icons/login.png'),
                            height: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    ActionButton(
                        buttonColor: Colors.white,
                        buttonText: "Login",
                        onTap: () async {
                          if (validateAndSave()) {
                            setState(() {
                              _isApiCallProcess = true;
                            });

                            requestModel.phone =
                                phoneController.text.toString();
                            requestModel.password =
                                passwordController.text.toString();

                            //apiService object is created for getting data from web-server through api
                            LoginService apiService = new LoginService();
                            apiService.login(requestModel).then(
                              (value) {
                                setState(() {
                                  _isApiCallProcess = false;
                                });

                                //Will print received data from web-server through api
                                print("Below data is got from api");
                                print(value.CI);
                                print(value.token);

                                //To store data in local storage
                                localStorage.setString(
                                    'phone', phoneController.text.toString());
                                localStorage.setString('Customer-ID', value.CI);
                                localStorage.setString(
                                    'Authorization', value.token);

                                if (value.token.isNotEmpty &&
                                    localStorage != null) {
                                  print(
                                      "Below data is printed from local storage");
                                  print(localStorage.get('phone'));
                                  print(localStorage.get('Customer-ID'));
                                  print(localStorage.get('Authorization'));
                                  Navigator.pushNamed(context, HomePage.id);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        value.error,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      width: 280.0, // Width of the SnackBar.
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            8.0, // Inner padding for SnackBar content.
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            );

                            print(requestModel.toJson());
                          }
                        },
                        textColor: kPrimaryColor),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
