import 'package:dd_app/utilities/action_button.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/model/register_third_details_update.dart';
import 'package:dd_app/api/reg_third_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/text_field_container.dart';
import 'package:dd_app/screens/authentication/login_screen.dart';

class RegistrationNewUser extends StatefulWidget {
  static const String id = "registration_new_user";

  @override
  _RegistrationNewUserState createState() => _RegistrationNewUserState();
}

class _RegistrationNewUserState extends State<RegistrationNewUser> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();
  RegisterThirdRequestModel requestModel;
  bool _hidePassword = true;
  bool _isApiCallProcess = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestModel = new RegisterThirdRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _UISetup(context),
      inAsyncCall: _isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _UISetup(BuildContext context) {
    Map<String, Object> receivedData =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                                        onSaved: (value) {
                                          requestModel.name = value.trim();
                                        },
                                        validator: (input) => input.isEmpty
                                            ? "Enter valid name"
                                            : null,
                                      ),
                                    ),
                                    TextFieldContainer(
                                      textField: TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: kLoginInputDecoration
                                            .copyWith(hintText: "Email"),
                                        style: TextStyle(),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (value) {
                                          requestModel.email = value.trim();
                                        },
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
                                        style: TextStyle(),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        maxLength: 50,
                                        onSaved: (input) =>
                                            requestModel.password = input,
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

                            RegisterServiceThird apiService =
                                new RegisterServiceThird();
                            apiService.login(requestModel).then((value) {
                              setState(() {
                                _isApiCallProcess = false;
                              });

                              if (value.message.isNotEmpty) {
                                print(value.message);
                                Navigator.pushNamed(
                                  context,
                                  LoginScreen.id,
                                );
                              } else {
                                print(value.message);
                              }
                            });

                            print(requestModel.toJson());
                          }
                        },
                        textColor: kPrimaryColor),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
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
