import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';

Column VendorCard(
    BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
  return Column(
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
            height: 115,
            width: MediaQuery.of(context).size.width * 0.90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: 115,
                  width: 122,
                  child: Image.network(
                    baseUrl +
                        "/" +
                        snapshot.data['data'][index]['vendor_profile_image']
                            .toString(),
                    fit: BoxFit.contain,
                    height: 115,
                    width: 122,
                  ),
                  // Image(
                  //   image: AssetImage(
                  //       'assets/images/homepage/6.jpg'),
                  // ),
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
                        Text(
                          snapshot.data['data'][index]['vendor_full_address']
                              .toString(),
                          style: TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          snapshot.data['data'][index]['discount_amount']
                                  .toString() +
                              "%",
                          style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data['data'][index]['vendor_phone']
                              .toString(),
                          style: TextStyle(
                            fontSize: 11.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 2,
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
      SizedBox(
        height: 10,
      ),
    ],
  );
}
