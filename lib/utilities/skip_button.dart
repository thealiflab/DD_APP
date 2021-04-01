import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final Function onTap;

  SkipButton({@required this.onTap});

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
        "Skip >",
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
