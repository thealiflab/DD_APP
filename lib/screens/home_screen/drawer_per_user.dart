import 'package:flutter/material.dart';

class DrawerPerUser extends StatelessWidget {
  const DrawerPerUser({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      child: DrawerHeader(
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
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  image: DecorationImage(
                    image: AssetImage('assets/images/homepage/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Mr Ahmed',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
