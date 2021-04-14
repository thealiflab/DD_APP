import 'package:flutter/material.dart';

class GuestLoginButton extends StatelessWidget {
  final Function onTap;

  GuestLoginButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.transparent,
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          50.0,
        ),
        side: BorderSide(
          color: Colors.white,
        ),
      ),
      onPressed: onTap,
      child: Text(
        "Guest Login >",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
