import 'package:dd_app/screens/authentication/registration_details.dart';
import 'package:dd_app/screens/authentication/reset_password.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:dd_app/api/enter_otp_api.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

//SharedPreferences
SharedPreferences localStorage;

class OTPCode extends StatefulWidget {
  static const String id = "verification_code";

  @override
  _OTPCodeState createState() => _OTPCodeState();
}

class _OTPCodeState extends State<OTPCode> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  String _OTP = "";

  Future sharedPrefFunc() async {
    localStorage = await SharedPreferences.getInstance();
  }

  OTPRequest requestModel;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  bool _isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    sharedPrefFunc();
    requestModel = new OTPRequest();
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
    Map<String, Object> receivedData =
        ModalRoute.of(context).settings.arguments;
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
                  height: MediaQuery.of(context).size.height * 0.15,
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
                                      'Enter the verification code',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 60),
                                      child: PinPut(
                                        fieldsCount: 4,
                                        onSubmit: (String otp) {
                                          _OTP = otp;
                                        },
                                        followingFieldDecoration: BoxDecoration(
                                          border: Border.all(
                                            color: kPrimaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        selectedFieldDecoration: BoxDecoration(
                                          border: Border.all(
                                            color: kLightPrimaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        submittedFieldDecoration: BoxDecoration(
                                          border: Border.all(
                                            color: kPrimaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        focusNode: _pinPutFocusNode,
                                        controller: _pinPutController,
                                        validator: (input) => input.isEmpty
                                            ? "Enter OTP Code correctly"
                                            : null,
                                      ),
                                    ),
                                    // Text(
                                    //   "Didn't receive a code?",
                                    //   style: TextStyle(
                                    //     color: Colors.black38,
                                    //   ),
                                    // ),
                                    // FlatButton(
                                    //   onPressed: () {},
                                    //   child: Text(
                                    //     'Resend',
                                    //     style: TextStyle(fontSize: 18),
                                    //   ),
                                    // )
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
                            image: AssetImage('assets/icons/otpicon.png'),
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.11,
                    ),
                    ActionButton(
                        buttonColor: Colors.white,
                        buttonText: "Confirm",
                        onTap: () {
                          if (validateAndSave()) {
                            setState(() {
                              _isApiCallProcess = true;
                            });
                            requestModel.otp = _OTP;
                            requestModel.phone = receivedData['phone'];

                            EnterOTPApi apiServices = EnterOTPApi();
                            apiServices.login(requestModel).then((value) {
                              setState(() {
                                _isApiCallProcess = false;
                              });

                              localStorage.setString(
                                  "Authorization", value.token.toString());
                              localStorage.setString(
                                  "Customer-ID", value.CI.toString());

                              if (value.status) {
                                if (localStorage.getBool("resetPassword")) {
                                  Navigator.pushNamed(
                                    context,
                                    ResetPassword.id,
                                  );
                                } else {
                                  Navigator.pushNamed(
                                    context,
                                    RegisterUserDetails.id,
                                  );
                                }
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
