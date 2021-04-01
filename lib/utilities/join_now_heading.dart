import 'package:flutter/material.dart';

class JoinNowHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 15),
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
      ],
    );
  }
}
