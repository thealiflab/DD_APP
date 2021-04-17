import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';

class DrawerPerUser extends StatelessWidget {
  final String imageURL;
  final String name;

  DrawerPerUser({@required this.imageURL, @required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kLightPrimaryColor,
              kPrimaryColor,
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
                    image: imageURL == null
                        ? AssetImage('assets/images/homepage/profile.jpg')
                        : NetworkImage(baseUrl + "/" + imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                name,
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
