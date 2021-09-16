import 'package:flutter/material.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:dd_app/api/claim_discount_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/api_constants.dart';
import 'dart:ui';

import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

ClaimDiscountRequest claimDiscountRequest;

AlertDialog claimNowAlertDialog(AsyncSnapshot<dynamic> snapshot,
    double distance, int index, BuildContext context) {
  return AlertDialog(
    title: Text(
      "Discount Claim",
      textAlign: TextAlign.center,
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: 122,
            child: snapshot.data['data'][index]['vendor_profile_image']
                        .toString() !=
                    null
                ? Image.network(
                    baseUrl +
                        "/" +
                        snapshot.data['data'][index]['vendor_profile_image']
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
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              snapshot.data['data'][index]['vendor_name'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              snapshot.data['data'][index]['vendor_description'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.0,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Discount ${snapshot.data['data'][index]['discount_amount']}%",
            style: TextStyle(
              fontSize: 26,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    launchMap(
                      snapshot.data['data'][index]['vendor_latitude'] ??
                          "37.3230",
                      snapshot.data['data'][index]['vendor_longitude'] ??
                          "122.0312",
                    );
                  },
                  child: Icon(
                    Icons.location_on,
                    size: 20,
                    color: kPrimaryColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    dial(snapshot.data['data'][index]['vendor_phone']
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
                    gotoWeb(snapshot.data['data'][index]['vendor_website']
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
                    gotoWeb(snapshot.data['data'][index]['vendor_facebook']
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
          )
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          if (distance < 10010000) {
            claimDiscountRequest = ClaimDiscountRequest();
            claimDiscountRequest.vendorUniqueId =
                snapshot.data['data'][index]['vendor_unique_id'].toString();

            print(snapshot.data['data'][index]['vendor_unique_id']);

            print(claimDiscountRequest.vendorUniqueId);

            //apiService object is created for getting data from web-server through api
            ClaimDiscountApi apiCL = ClaimDiscountApi();
            apiCL.claim(claimDiscountRequest).then((value) {
              if (value.status) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  snackBarMessage(
                    value.message.toString(),
                    true,
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  snackBarMessage(
                    value.message.toString(),
                    false,
                  ),
                );
              }
            });
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarMessage(
                "Vendor isn't located in 1 KM Radius",
                false,
              ),
            );
          }
        },
        child: Text(
          "Claim Now",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.green,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.redAccent,
          ),
        ),
      )
    ],
  );
}

//URL Launcher functions
dial(String phoneNumber) async {
  var dial = 'tel:$phoneNumber';
  if (await canLaunch(dial)) {
    await launch(dial);
  } else {
    throw 'Could not launch $dial';
  }
}

//<=========== Open Map
launchMap(lat, lng) async {
  String homeLat = lat.toString() ?? "37.3230";
  String homeLng = lng.toString() ?? "122.0312";

  final String googleMapslocationUrl =
      "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

  final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

  if (await canLaunch(encodedURl)) {
    await launch(encodedURl);
  } else {
    print('Could not launch $encodedURl');
    throw 'Could not launch $encodedURl';
  }
}

goToEmail(String email) async {
  if (await canLaunch("mailto:$email")) {
    await launch("mailto:$email");
  } else {
    throw 'Could not launch';
  }
}

gotoWeb(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
