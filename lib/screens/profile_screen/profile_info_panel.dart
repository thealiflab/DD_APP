import 'package:flutter/material.dart';

class ProfileInfoPanel extends StatelessWidget {
  ProfileInfoPanel({@required this.textIcon, @required this.info});

  final IconData textIcon;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFedeef7),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                textIcon,
                color: Color(0xFF24b5c4),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  info,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
