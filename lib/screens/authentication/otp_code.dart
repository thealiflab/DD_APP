import 'file:///D:/PROJECTS/AndroidStudioProjects/dd_app/lib/screens/authentication/registration_details.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:dd_app/model/register_second_otp.dart';
import 'package:dd_app/api/reg_second_api.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/join_now_heading.dart';

class OTPCode extends StatefulWidget {
  static const String id = "verification_code";

  @override
  _OTPCodeState createState() => _OTPCodeState();
}

class _OTPCodeState extends State<OTPCode> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  String _OTP = "";

  RegisterSecondRequestModel requestModel;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  bool _isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = new RegisterSecondRequestModel();
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
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    ActionButton(
                        buttonColor: Colors.white,
                        buttonText: "Confirm",
                        onTap: () {
                          requestModel.otp = _OTP;
                          requestModel.phone = receivedData['phone'];

                          if (validateAndSave()) {
                            setState(() {
                              _isApiCallProcess = true;
                            });

                            RegisterServiceSecond apiServices =
                                RegisterServiceSecond();
                            apiServices.login(requestModel).then((value) {
                              setState(() {
                                _isApiCallProcess = false;
                              });

                              //TODO change this and handle this with state management
                              print(value.CI);

                              print(value.token);

                              if (value.token.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  RegistrationNewUser.id,
                                );
                              } else {
                                print(value.error);
                                print('API not called properly');
                              }
                            });

                            print(requestModel.toJson());
                          }
                        },
                        textColor: kPrimaryColor),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.13,
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