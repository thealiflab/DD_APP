import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'vendor_details.dart';
import 'claim_now_alert_dialog.dart';

GestureDetector vendorCard(
    BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return claimNowAlertDialog(snapshot, index, context);
          });
    },
    child: VendorDetails(
      snapshot: snapshot,
      index: index,
    ),
  );
}
