import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/api/renew_subscription_api.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';

class Payment extends StatefulWidget {
  static const String id = "payment";
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  //For API Call
  Future<dynamic> renewSubApiData;
  RenewSubAPI renewSubAPI = RenewSubAPI();

  int monthNumber = 1;
  int feeAmount = 100;
  var fee;
  bool isButtonNotPressed = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Subscription',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, HomePage.id);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        monthNumber--;
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text("$monthNumber month"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        monthNumber++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                fee = monthNumber * feeAmount;
                renewSubAPI
                    .getData("$monthNumber", "bkash", "$fee")
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBarMessage(
                      value['message'].toString(),
                      true,
                    ),
                  );
                });
              },
              child: Text('Pay Amount'),
            ),
          ],
        ),
      ),
    );
  }
}
