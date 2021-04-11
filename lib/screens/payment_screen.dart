import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/api/renew_subscription_api.dart';

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
              Navigator.pop(context);
            },
          ),
        ),
        body: isButtonNotPressed
            ? Column(
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
                      renewSubAPI.getData("$monthNumber", "bkash", "$fee");
                      setState(() {
                        isButtonNotPressed = !isButtonNotPressed;
                      });
                    },
                    child: Text('Pay Amount'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: FutureBuilder<dynamic>(
                          future: renewSubAPI.getData(
                              "$monthNumber", "bkash", "$fee"),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data['status'].toString() ==
                                  "true") {
                                print(snapshot.data['message'].toString());
                                return Text(
                                  snapshot.data['message'].toString(),
                                  style: TextStyle(fontSize: 18),
                                );
                              } else {
                                print(snapshot.data['message'].toString());
                                return Text(
                                  snapshot.data['message'].toString(),
                                );
                              }
                            } else {
                              return Text("No Data Found!");
                            }
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
