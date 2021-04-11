import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'file:///D:/PROJECTS/AndroidStudioProjects/dd_app/lib/utilities/claim_now_alert_dialog.dart';

class VendorDetails extends StatelessWidget {
  final BuildContext context;
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  const VendorDetails(
      {@required this.context, @required this.snapshot, @required this.index});

  //URL Launcher functions
  _dial(String phoneNumber) async {
    var dial = 'tel:$phoneNumber';
    if (await canLaunch(dial)) {
      await launch(dial);
    } else {
      throw 'Could not launch $dial';
    }
  }

  _email(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

  _gotoWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 4.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Container(
              height: 125,
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 115,
                    width: 122,
                    child: snapshot.data['data'][index]['vendor_profile_image']
                                .toString() !=
                            null
                        ? Image.network(
                            baseUrl +
                                "/" +
                                snapshot.data['data'][index]
                                        ['vendor_profile_image']
                                    .toString(),
                            fit: BoxFit.contain,
                            height: 115,
                            width: 122,
                          )
                        : Image.asset(
                            "assets/images/homepage/1.jpg",
                            fit: BoxFit.contain,
                            height: 115,
                            width: 122,
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              snapshot.data['data'][index]['vendor_name']
                                  .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data['data'][index]['discount_amount']
                                    .toString() +
                                "%",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _email(snapshot.data['data'][index]
                                            ['vendor_email']
                                        .toString());
                                  },
                                  child: Icon(
                                    Icons.email_rounded,
                                    size: 20,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _dial(snapshot.data['data'][index]
                                            ['vendor_phone']
                                        .toString());
                                  },
                                  child: Icon(
                                    Icons.phone_android_rounded,
                                    size: 20,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _gotoWeb(snapshot.data['data'][index]
                                            ['vendor_website']
                                        .toString());
                                  },
                                  child: Icon(
                                    Icons.public_rounded,
                                    size: 20,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _gotoWeb(snapshot.data['data'][index]
                                            ['vendor_facebook']
                                        .toString());
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/facebook.svg',
                                    width: 20,
                                    height: 20,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return claimNowAlertDialog(
                                snapshot, index, context);
                          });
                    },
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    child: Transform.rotate(
                      angle: pi / -2,
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kPrimaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              offset: Offset(2.0, 4.4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Claim',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
