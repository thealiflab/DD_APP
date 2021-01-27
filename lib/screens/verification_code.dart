import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificationCode extends StatefulWidget {
  static const String id = "verification_code";

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        child: Flexible(
                          flex: 2,
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
                                        vertical: 15, horizontal: 15),
                                    child: PinFieldAutoFill(
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      decoration: UnderlineDecoration(
                                        textStyle: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        colorBuilder: FixedColorBuilder(
                                            Colors.black.withOpacity(0.3)),
                                      ),
                                      // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
                                      // currentCode: // prefill with a code
                                      // onCodeSubmitted: //code submitted callback
                                      // onCodeChanged: //code changed callback
                                      codeLength: 4, //code length, default 6
                                    ),
                                  ),
                                  Text(
                                    "Didn't receive a code?",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      //something
                                    },
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
                      /*...*/
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
                        /*...*/
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
    );
  }
}
