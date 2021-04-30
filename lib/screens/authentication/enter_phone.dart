import 'package:dd_app/screens/authentication/otp_code.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/api/enter_phone_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:dd_app/utilities/text_field_container.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sms_autofill/sms_autofill.dart';

class EnterPhone extends StatefulWidget {
  static const String id = "enter_your_phone";

  @override
  _EnterPhoneState createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();
  PhoneRequest requestModel;
  bool _isApiCallProcess = false;
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";
  @override
  void initState() {
    super.initState();
    requestModel = new PhoneRequest();
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
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
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
                                  'Enter Your Phone Number',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldContainer(
                                  textField: InternationalPhoneNumberInput(
                                    onInputChanged: (PhoneNumber number) {
                                      print(number.phoneNumber);
                                      setState(() {
                                        requestModel.phone = number.phoneNumber;
                                        phoneNumber = number.phoneNumber;
                                      });
                                    },
                                    validator: (input) => input.isEmpty
                                        ? "Mobile is Empty"
                                        : null,

                                    // onInputValidated: (bool value) {
                                    //   print(value);
                                    // },
                                    selectorConfig: SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: true,
                                    selectorTextStyle:
                                        TextStyle(color: Colors.black),
                                    formatInput: false,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: false),
                                    inputBorder: OutlineInputBorder(),
                                    onSaved: (PhoneNumber number) {
                                      print('On Saved: $number');
                                    },
                                  ),
                                ),
                                // TextFieldContainer(
                                //   textField: TextFormField(
                                //     controller: phoneController,
                                //     textAlign: TextAlign.center,
                                //     decoration: kLoginInputDecoration,
                                //     keyboardType: TextInputType.phone,
                                //     maxLength: 11,
                                //     validator: (input) =>
                                //         input.length < 11 || input.isEmpty
                                //             ? "Phone Number should be valid"
                                //             : null,
                                //   ),
                                // ),
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
                  buttonText: "Enter",
                  onTap: () {
                    if (validateAndSave()) {
                      setState(() {
                        _isApiCallProcess = true;
                      });

                      //phone number send to api
                      // requestModel.phone =phoneNumber;

                      EnterPhoneApi apiService = new EnterPhoneApi();
                      apiService.login(requestModel).then((value) async {
                        setState(() {
                          _isApiCallProcess = false;
                        });

                        if (value.status) {
                          final signCode = await SmsAutoFill().getAppSignature;
                          print("App Signature $signCode");
                          Navigator.pushNamed(
                            context,
                            OTPCode.id,
                            arguments: {
                              "phone": requestModel.phone,
                            },
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
                  textColor: kPrimaryColor,
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
