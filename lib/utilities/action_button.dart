import 'package:flutter/material.dart';
import 'constants.dart';

class ActionButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Function onTap;
  final Color textColor;

  ActionButton(
      {@required this.buttonColor,
      @required this.buttonText,
      @required this.onTap,
      @required this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
        overlayColor: buttonColor == Colors.white
            ? MaterialStateProperty.all(kLightPrimaryColor)
            : MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: 15,
            horizontal: buttonText == "Registration"
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width * 0.33,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              50.0,
            ),
            side: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
      onPressed: onTap,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 20.0,
          color: textColor,
        ),
      ),
    );
  }
}
