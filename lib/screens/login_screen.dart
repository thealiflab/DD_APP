import 'package:dd_app/api/web_api.dart';
import 'package:dd_app/model/login_user_model.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/screens/otp_code.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/api/global_ref_values.dart' as ref;

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

  @override
  void initState() {
    super.initState();
    requestModel = new LoginRequestModel();
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
      key: _scaffoldKey,
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
                                top: 58,
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
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 30,
                                        ),
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(50.0),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFFf9f9f9),
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                            hintText: "Phone",
                                          ),
                                          style: TextStyle(),
                                          keyboardType: TextInputType.phone,
                                          maxLength: 11,
                                          onSaved: (input) =>
                                              requestModel.phone = input,
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
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(50.0),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFFf9f9f9),
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                            hintText: "Password",
                                            suffixIcon: IconButton(
                                              icon: Icon(_hidePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  _hidePassword =
                                                      !_hidePassword;
                                                });
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
                      height: 15,
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
                        if (validateAndSave()) {
                          setState(() {
                            _isApiCallProcess = true;
                          });

                          LoginService apiService = new LoginService();
                          apiService.login(requestModel).then((value) {
                            setState(() {
                              _isApiCallProcess = false;
                            });

                            //TODO change this and handle this with state management
                            print(value.CI);
                            ref.CI = value.CI;
                            print(value.token);
                            ref.token = value.token;

                            if (value.token.isNotEmpty) {
                              final snackBar = SnackBar(
                                content: Text("Login Successful"),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                              Navigator.pushNamed(context, HomePage.id);
                            } else {
                              final snackBar = SnackBar(
                                content: Text(value.error),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          });

                          print(requestModel.toJson());
                        }
                        // Navigator.pushNamed(context, HomePage.id);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.10,
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
                          Navigator.pushNamed(context, OTPCode.id);
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
