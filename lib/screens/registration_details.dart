import 'home_screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/progressHUD.dart';
import 'package:dd_app/model/register_third_details_update.dart';
import 'package:dd_app/api/reg_third_api.dart';

class RegistrationNewUser extends StatefulWidget {
  static const String id = "registration_new_user";

  @override
  _RegistrationNewUserState createState() => _RegistrationNewUserState();
}

class _RegistrationNewUserState extends State<RegistrationNewUser> {
  GlobalKey<FormState> _globalFormKey = new GlobalKey<FormState>();
  RegisterThirdRequestModel requestModel;
  bool _isApiCallProcess = false;

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
                                      'Enter Profile Details',
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
                                          vertical: 10,
                                          horizontal: 30,
                                        ),
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(50.0),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintStyle: TextStyle(
                                              color: Colors.black54,
                                            ),
                                            hintText: "Full Name",
                                          ),
                                          style: TextStyle(),
                                          keyboardType: TextInputType.text,
                                          onSaved: (value) {
                                            requestModel.name = value.trim();
                                          },
                                          validator: (input) => input.isEmpty
                                              ? "Enter valid name"
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 400,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 30,
                                        ),
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(50.0),
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintStyle: TextStyle(
                                              color: Colors.black54,
                                            ),
                                            hintText: "Email Address",
                                          ),
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      color: Colors.white,
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
                                HomePage.id,
                              );
                            } else {
                              print(value.message);
                            }
                          });

                          print(requestModel.toJson());
                        }
                        // Navigator.pushNamed(context, HomePage.id);
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
                          Navigator.pushNamed(context, HomePage.id);
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
