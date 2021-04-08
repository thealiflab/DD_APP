import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/api/renew_subscription_api.dart';

class Subscription extends StatefulWidget {
  static const String id = "subscription";
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  //For API Call
  Future<dynamic> renewSubApiData;
  RenewSubAPI renewSubAPI = RenewSubAPI();

  int monthNumber = 1;
  int feeAmount = 100;

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
              Navigator.pop(context);
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
                var fee = monthNumber * feeAmount;
                FutureBuilder<dynamic>(
                    future:
                        renewSubAPI.getData("$monthNumber", "bkash", "$fee"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['status'].toString() == "true") {
                          print(snapshot.data['message'].toString());
                          return Text(snapshot.data['message'].toString());
                        } else {
                          print(snapshot.data['message'].toString());
                          return Text(snapshot.data['message'].toString());
                        }
                      } else {
                        return Text("No Data Found!");
                      }
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
