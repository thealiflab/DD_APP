import 'package:dd_app/api/payment_history_api.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';

class PaymentHistory extends StatefulWidget {
  static const String id = "payment_history";
  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  //For API Call
  PaymentHistoryAPI paymentHistoryAPI = PaymentHistoryAPI();
  String isSubscriptionExpired = "";

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Payment History",
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
      body: Container(
        height: _height,
        width: _width,
        child: FutureBuilder<dynamic>(
          future: paymentHistoryAPI.getPaymentHistory(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  itemCount:
                      snapshot.data['data']['subscriptionHistory'].length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    //Checking subscribe status
                    isSubscriptionExpired = snapshot.data['data']
                            ['subscriptionHistory'][index]['expired']
                        .toString();
                    return paymentHistoryCard(snapshot, index);
                  });
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }

  Card paymentHistoryCard(AsyncSnapshot<dynamic> snapshot, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Icon(
                  isSubscriptionExpired == "0" ? Icons.done : Icons.history,
                  color: isSubscriptionExpired == "0"
                      ? Colors.green
                      : Colors.redAccent,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Subscription Purchased",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                snapshot.data['data']['subscriptionHistory'][index]
                            ['subscription_date_time']
                        .toString() ??
                    "No data found",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 10,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "For " +
                    (snapshot.data['data']['subscriptionHistory'][index]
                            ['subscription_limit']
                        .toString()) +
                    " month",
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              ),
            ),
            Center(
              child: Text(
                (snapshot.data['data']['subscriptionHistory'][index]
                                ['payment_amount']
                            .toString() ??
                        "0") +
                    " BDT",
                style: TextStyle(
                  color: isSubscriptionExpired == "0"
                      ? Colors.green
                      : Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "transaction ID: " +
                      snapshot.data['data']['subscriptionHistory'][index]
                              ['transaction_id']
                          .toString() ??
                  "No data found",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                snapshot.data['data']['subscriptionHistory'][index]
                            ['subscription_expire_date_time']
                        .toString() ??
                    "No data found",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
