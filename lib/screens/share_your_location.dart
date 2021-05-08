import 'package:dd_app/screens/authentication/login_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';

class ShareYourLocation extends StatefulWidget {
  static const String id = "share_your_location";

  @override
  _ShareYourLocationState createState() => _ShareYourLocationState();
}

class _ShareYourLocationState extends State<ShareYourLocation> {
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
              kPrimaryColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/map.png'),
              height: MediaQuery.of(context).size.width * 0.45,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Share Your Location To get\nmore Customized Experience',
              style: TextStyle(
                height: 1.5,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FlatButton(
              color: Colors.white,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              splashColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              onPressed: () {
                //locationEnable();
              },
              child: Text(
                "Share Your Location",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.23,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
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
                        Navigator.pushNamed(context, LoginRegister.id);
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
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
