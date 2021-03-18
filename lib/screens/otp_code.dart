import 'package:dd_app/screens/registration_details.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:dd_app/model/register_second_otp.dart';
import 'package:dd_app/api/reg_second_api.dart';
import 'package:dd_app/progressHUD.dart';

class OTPCode extends StatefulWidget {
  static const String id = "verification_code";

  @override
  _OTPCodeState createState() => _OTPCodeState();
}

class _OTPCodeState extends State<OTPCode> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();

  String _OTP = "";

  RegisterSecondRequestModel requestModel = RegisterSecondRequestModel();

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  bool _isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
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
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF34d3ae),
                Color(0xFF24b5c4),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 50, top: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Join now for\nMaximum deals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  height: 20,
                  thickness: 3,
                  indent: 50,
                  endIndent: 50,
                ),
                Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/openingthemeimage.png'),
                      height: MediaQuery.of(context).size.width * 0.45,
                    ),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 20,
                            right: 10,
                            bottom: 10,
                          ),
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 58,
                                bottom: 10,
                              ),
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
                                            color: Color(0xFF24b5c4),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        selectedFieldDecoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF34d3ae),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        submittedFieldDecoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF24b5c4),
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
                                    Text(
                                      "Didn't receive a code?",
                                      style: TextStyle(
                                        color: Colors.black38,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Resend',
                                        style: TextStyle(fontSize: 18),
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
                            image: AssetImage('assets/icons/otpicon.png'),
                            height: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                      ),
                      onPressed: () {
                        requestModel.otp = _OTP;
                        requestModel.phone = receivedData['phone'];

                        print("success 1");
                        print(requestModel.otp);
                        print(requestModel.phone);

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
                            print("success 2");
                            print(value.CI);
                            print(value.token);

                            if (value.token.isNotEmpty) {
                              Navigator.pushNamed(
                                  context, RegistrationNewUser.id);
                            } else {
                              print(value.error);
                              print('API not called properly');
                            }
                          });

                          print(requestModel.toJson());
                        }
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        color: Colors.transparent,
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            50.0,
                          ),
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationNewUser.id);
                        },
                        child: Text(
                          "Skip >",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
