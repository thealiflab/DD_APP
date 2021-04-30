import 'package:dd_app/utilities/action_button.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/api/user_details_update_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/text_field_container.dart';
import 'package:dd_app/screens/authentication/login_screen.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';

class ResetPassword extends StatefulWidget {
  static const String id = "reset_password";

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  bool _hidePassword = true;
  bool _isApiCallProcess = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController resetPasswordController = TextEditingController();

  UpdateDetailsRequest requestModel;

  @override
  void initState() {
    super.initState();
    requestModel = new UpdateDetailsRequest();
  }

  @override
  void dispose() {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: kPageBackgroundGradientEffect,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                          padding: kCardPadding,
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: kFormPadding,
                              child: Form(
                                key: _globalFormKey,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFieldContainer(
                                      textField: TextFormField(
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
                                        autofocus: false,
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
                                    TextFieldContainer(
                                      textField: TextFormField(
                                        controller: resetPasswordController,
                                        textAlign: TextAlign.center,
                                        decoration:
                                            kLoginInputDecoration.copyWith(
                                          hintText: "Confirm Password",
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
                                        autofocus: false,
                                        obscureText: _hidePassword,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        maxLength: 50,
                                        validator: (input) =>
                                            input.length < 6 ||
                                                    input.isEmpty ||
                                                    resetPasswordController.text
                                                            .toString() !=
                                                        passwordController.text
                                                            .toString()
                                                ? "Password not valid or match"
                                                : null,
                                      ),
                                    ),
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
                            image: AssetImage('assets/icons/user.png'),
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                    ),
                    ActionButton(
                        buttonColor: Colors.white,
                        buttonText: "Register",
                        onTap: () {
                          if (validateAndSave()) {
                            setState(() {
                              _isApiCallProcess = true;
                            });

                            requestModel.password =
                                passwordController.text.toString();

                            UserDetailsUpdate apiService =
                                new UserDetailsUpdate();
                            apiService.login(requestModel).then((value) {
                              setState(() {
                                _isApiCallProcess = false;
                              });

                              if (value.status) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarMessage(
                                    "Password Changed Successfully!",
                                    true,
                                  ),
                                );

                                Navigator.pushNamed(
                                  context,
                                  LoginScreen.id,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarMessage(
                                    value.message.toString(),
                                    false,
                                  ),
                                );
                              }
                            });
                          }
                        },
                        textColor: kPrimaryColor),
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
