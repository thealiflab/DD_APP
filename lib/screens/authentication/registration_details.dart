import 'package:dd_app/utilities/action_button.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/api/user_details_update_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/text_field_container.dart';
import 'package:dd_app/screens/authentication/login_screen.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';

class RegisterUserDetails extends StatefulWidget {
  static const String id = "registration_new_user";

  @override
  _RegisterUserDetailsState createState() => _RegisterUserDetailsState();
}

class _RegisterUserDetailsState extends State<RegisterUserDetails> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  bool _hidePassword = true;
  bool _isApiCallProcess = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          decoration: kPageBackgroundGradientEffect,
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
                  height: MediaQuery.of(context).size.height * 0.04,
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
                                      'Enter Profile Details',
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
                                        controller: fullNameController,
                                        textAlign: TextAlign.center,
                                        decoration: kLoginInputDecoration
                                            .copyWith(hintText: "Full Name"),
                                        keyboardType: TextInputType.text,
                                        validator: (input) => input.isEmpty
                                            ? "Enter valid name"
                                            : null,
                                      ),
                                    ),
                                    TextFieldContainer(
                                      textField: TextFormField(
                                        controller: emailController,
                                        textAlign: TextAlign.center,
                                        decoration: kLoginInputDecoration
                                            .copyWith(hintText: "Email"),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          Pattern pattern =
                                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                              r"{0,253}[a-zA-Z0-9])?)*$";
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value) ||
                                              value.isEmpty)
                                            return 'Enter a valid email address';
                                          else
                                            return null;
                                        },
                                      ),
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
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    ActionButton(
                        buttonColor: Colors.white,
                        buttonText: "Register",
                        onTap: () {
                          if (validateAndSave()) {
                            setState(() {
                              _isApiCallProcess = true;
                            });

                            requestModel.name =
                                fullNameController.text.toString();
                            requestModel.email =
                                emailController.text.toString();
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
                                    "Registration Success!",
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
