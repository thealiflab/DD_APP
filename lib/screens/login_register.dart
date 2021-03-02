import 'package:flutter/material.dart';

class LoginRegister extends StatefulWidget {
  static const String id = "deal_swiper";

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
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
              Image(
                image: AssetImage('assets/images/ddlogow.png'),
                height: MediaQuery.of(context).size.width * 0.45,
              ),
              Text(
                'Dream Destination',
                style: TextStyle(
                  height: 2,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 100,
              ),
              FlatButton(
                color: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 92,
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
                  "Registration",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              FlatButton(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 120,
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
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF24b5c4),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
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
        ),
      ),
    );
  }
}
