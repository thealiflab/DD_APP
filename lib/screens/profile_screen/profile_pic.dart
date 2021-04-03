import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dd_app/utilities/constants.dart';

class ProfilePic extends StatelessWidget {
  final String imageURL;

  ProfilePic({@required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: imageURL == null
                ? AssetImage('assets/images/homepage/profile.jpg')
                : NetworkImage(baseUrl + "/" + imageURL),
          ),
          Positioned(
            bottom: 0,
            right: -12,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  //something
                },
                child: SvgPicture.asset("assets/icons/camera.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
