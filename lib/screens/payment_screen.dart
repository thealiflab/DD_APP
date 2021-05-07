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

  int monthNumber = 0;
  int totalFee = 0;
  int fee = 0;
  bool isButtonNotPressed = true;

  String regFee = "0";
  String subscriptionFee = "0";

  @override
  void initState() {
    super.initState();
    RenewSubAPI().getRegistrationFee().then((value) {
      setState(() {
        regFee = value["optionValue"];
      });
    });
    RenewSubAPI().getSubscriptionFee().then((value) {
      setState(() {
        subscriptionFee = value["optionValue"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
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
          actions: [
            Center(
              child: Text(
                "Unregistered ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Registration fee : $regFee/- Tk",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Subscription : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (monthNumber > 1) {
                        setState(() {
                          monthNumber--;
                        });
                        fee = monthNumber * int.parse(subscriptionFee);
                      }
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text("$monthNumber month"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        monthNumber++;
                      });
                      fee = monthNumber * int.parse(subscriptionFee);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Subscription fee : $fee/- Tk",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "Total fee : ${fee + int.parse(regFee)}/- Tk",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                fee = monthNumber * int.parse(subscriptionFee);
                renewSubAPI
                    .getData(
                        "$monthNumber", "bkash", "${fee + int.parse(regFee)}")
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
        bottomSheet: Container(
          padding: EdgeInsets.all(15),
          width: _width,
          height: 60,
          child: Text(
            "Note :  Here, 1 month = 30 days ",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
