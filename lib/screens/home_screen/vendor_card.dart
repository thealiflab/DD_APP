import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/screens/home_screen/claim_now.dart';
import 'package:dd_app/api/claim_discount_api.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';

ClaimDiscountRequest claimDiscountRequest;

Future apiCall() async {
  claimDiscountRequest = ClaimDiscountRequest();
}

GestureDetector vendorCard(
    BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Discount Claim",
                textAlign: TextAlign.center,
              ),
              content: claimNow(snapshot, index),
              actions: [
                TextButton(
                  onPressed: () async {
                    claimDiscountRequest.vendorUniqueId = snapshot.data['data']
                            [index]['vendor_unique_id']
                        .toString();

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
          });
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          child: Container(
            height: 115,
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
              height: 120,
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
                          Text(
                            snapshot.data['data'][index]['vendor_name']
                                .toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data['data'][index]
                                      ['vendor_full_address']
                                  .toString(),
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            snapshot.data['data'][index]['discount_amount']
                                    .toString() +
                                "%",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
