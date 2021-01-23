import 'package:flutter/material.dart';

class OpeningScreen extends StatelessWidget {
  static const String id = "openning_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
