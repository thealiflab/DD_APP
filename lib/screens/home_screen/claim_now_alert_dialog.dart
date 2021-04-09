import 'package:flutter/material.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:dd_app/api/claim_discount_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

ClaimDiscountRequest claimDiscountRequest;

Future apiCall() async {
  claimDiscountRequest = ClaimDiscountRequest();
}

AlertDialog claimNowAlertDialog(
    AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
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

  return AlertDialog(
    title: Text(
      "Discount Claim",
      textAlign: TextAlign.center,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.22,
          width: 122,
          child:
              snapshot.data['data'][index]['vendor_profile_image'].toString() !=
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
        Text(
          snapshot.data['data'][index]['vendor_name'].toString(),
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          snapshot.data['data'][index]['vendor_description'].toString(),
          style: TextStyle(
            fontSize: 11.0,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5),
        Text(
          snapshot.data['data'][index]['discount_amount'].toString() + "%",
          style: TextStyle(fontSize: 22, color: kPrimaryColor),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _email(snapshot.data['data'][index]['vendor_email'].toString());
              },
              icon: Icon(Icons.email_rounded),
            ),
            IconButton(
              onPressed: () {
                _dial(snapshot.data['data'][index]['vendor_phone'].toString());
              },
              icon: Icon(Icons.phone_android_rounded),
            ),
            IconButton(
              onPressed: () {
                _gotoWeb(
                    snapshot.data['data'][index]['vendor_website'].toString());
              },
              icon: Icon(Icons.public_rounded),
            ),
            IconButton(
              onPressed: () {
                // _gotoWeb(
                //     snapshot.data['data'][index]['vendor_facebook'].toString());
              },
              icon: SvgPicture.asset(
                'assets/icons/facebook.svg',
                width: 25,
                height: 25,
              ),
            ),
          ],
        )
      ],
    ),
    actions: [
      TextButton(
        onPressed: () async {
          claimDiscountRequest.vendorUniqueId =
              snapshot.data['data'][index]['vendor_unique_id'].toString();

          print(claimDiscountRequest.vendorUniqueId);

          //apiService object is created for getting data from web-server through api
          ClaimDiscountApi apiCL = new ClaimDiscountApi();
          apiCL.login(claimDiscountRequest).then((value) {
            if (value.status) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                snackBarMessage(
                  value.message.toString(),
                  true,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                snackBarMessage(
                  value.message.toString(),
                  false,
                ),
              );
            }
          });
        },
        child: Text(
          "Claim Now",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
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
            color: Colors.black,
          ),
        ),
      )
    ],
  );
}
