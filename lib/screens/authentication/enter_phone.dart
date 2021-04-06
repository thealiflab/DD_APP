import 'file:///D:/PROJECTS/AndroidStudioProjects/dd_app/lib/screens/authentication/otp_code.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/model/register_first_phone.dart';
import 'package:dd_app/api/reg_first_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/join_now_heading.dart';
import 'package:dd_app/utilities/text_field_container.dart';

class EnterPhone extends StatefulWidget {
  static const String id = "enter_your_phone";

  @override
  _EnterPhoneState createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();
  RegisterFirstRequestModel requestModel;
  bool _isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    requestModel = new RegisterFirstRequestModel();
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
                                  textField: TextFormField(
                                    textAlign: TextAlign.center,
                                    decoration: kLoginInputDecoration,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 11,
                                    onSaved: (input) =>
                                        requestModel.phone = input,
                                    validator: (input) =>
                                        input.length < 11 || input.isEmpty
                                            ? "Phone Number should be valid"
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
                        image: AssetImage('assets/icons/login.png'),
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
                  buttonText: "Enter",
                  onTap: () {
                    if (validateAndSave()) {
                      setState(() {
                        _isApiCallProcess = true;
                      });

                      RegisterServiceFirst apiService =
                          new RegisterServiceFirst();
                      apiService.login(requestModel).then((value) {
                        setState(() {
                          _isApiCallProcess = false;
                        });

                        print(value.message);

                        if (value.status) {
                          Navigator.pushNamed(
                            context,
                            OTPCode.id,
                            arguments: {
                              "phone": requestModel.phone,
                            },
                          );
                        } else {
                          print('API not called properly');
                          print(value.error);
                        }
                      });

                      print(requestModel.toJson());
                    }
                  },
                  textColor: kPrimaryColor,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
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
