import 'package:flutter/material.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:dd_app/api/claim_discount_api.dart';
import 'package:dd_app/utilities/constants.dart';
import 'dart:ui';

ClaimDiscountRequest claimDiscountRequest;

AlertDialog claimNowAlertDialog(
    AsyncSnapshot<dynamic> snapshot, int index, BuildContext context) {
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
          snapshot.data['data'][index]['discount_amount'].toString() + "%",
          style: TextStyle(
            fontSize: 26,
            color: kPrimaryColor,
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () async {
          claimDiscountRequest = ClaimDiscountRequest();
          claimDiscountRequest.vendorUniqueId =
              snapshot.data['data'][index]['vendor_unique_id'].toString();

          print(snapshot.data['data'][index]['vendor_unique_id']);

          print(claimDiscountRequest.vendorUniqueId);

          //apiService object is created for getting data from web-server through api
          ClaimDiscountApi apiCL = ClaimDiscountApi();
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
