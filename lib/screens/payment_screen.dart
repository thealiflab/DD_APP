import 'package:custom_timer/custom_timer.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:dd_app/model/customer_info_model.dart';
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
  final CustomTimerController _timerController = new CustomTimerController();
  //For API Call
  Future<dynamic> renewSubApiData;
  RenewSubAPI renewSubAPI = RenewSubAPI();

  Future<CustomerInfoGetModel> futureCustomerInfoGetModel;

  int monthNumber = 0;
  int totalFee = 0;
  int fee = 0;
  bool isButtonNotPressed = true;

  int regFee = 0;
  int subscriptionFee = 0;

  @override
  void initState() {
    subscriptionExpiryDate();
    futureCustomerInfoGetModel = UserInfoAPI().getUserInfo();

    super.initState();
    RenewSubAPI().getRegistrationFee().then((value) {
      setState(() {
        regFee = int.parse(value["optionValue"]);
      });
    });
    RenewSubAPI().getSubscriptionFee().then((value) {
      setState(() {
        subscriptionFee = int.parse(value["optionValue"]);
      });
    });
  }

  int subscriptionMinutesRemaining = 0;

  subscriptionExpiryDate() {
    UserInfoAPI().getUserInfo().then((value) {
      final DateTime todayDateTime = DateTime.now();
      DateTime subscriptionExpiredDate =
          DateTime.parse(value.lastSubscriptionExpireDate);
      setState(() {
        subscriptionMinutesRemaining =
            subscriptionExpiredDate.difference(todayDateTime).inMinutes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Payment',
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
          child: FutureBuilder<CustomerInfoGetModel>(
              future: futureCustomerInfoGetModel,
              builder: (context, snapshot) {
                if (!snapshot.hasError) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: Text(
                          "Offline!",
                          style: TextStyle(fontSize: 24, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      );
                    case ConnectionState.waiting:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                            ),
                            child: Text(
                              "Please Wait",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          )
                        ],
                      );

                      break;
                    default:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          snapshot.data.isRegistered
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Registered ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.green),
                                  ),
                                )
                              : Align(
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
                          SizedBox(
                            height: 20,
                          ),
                          // <================================ Show Subscription Timer
                          Visibility(
                            visible: !snapshot.data.isSubscriptionExpired,
                            child: CustomTimer(
                              controller: _timerController,
                              from:
                                  Duration(hours: subscriptionMinutesRemaining),
                              to: Duration(hours: 0),
                              interval: Duration(seconds: 1),
                              onBuildAction: CustomTimerAction.auto_start,
                              builder: (CustomTimerRemainingTime remaining) {
                                return Row(
                                  children: [
                                    Text("Time Remaining : "),
                                    Text(
                                      "  ${remaining.days} days :${remaining.hours} hours:${remaining.minutes} minutes",
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: int.parse(remaining.days) > 5
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Visibility(
                              visible: snapshot.data.isSubscriptionExpired,
                              child: Text("No Subscription Remaining")),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Subscription fee : $subscriptionFee/- Tk",
                              style: TextStyle(
                                fontSize: 16,
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
                                      fee = monthNumber * subscriptionFee;
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
                                    fee = monthNumber * subscriptionFee;
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
                            alignment: Alignment.topRight,
                            child: Text(
                              snapshot.data.isRegistered
                                  ? "Total fee : $fee/- Tk"
                                  : "Total fee : ${fee + regFee}/- Tk",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: monthNumber > 0,
                            child: ElevatedButton(
                              onPressed: () {
                                fee = monthNumber * subscriptionFee;
                                renewSubAPI
                                    .getData(
                                        "$monthNumber",
                                        "bkash",
                                        snapshot.data.isRegistered
                                            ? "$fee"
                                            : "${fee + regFee}")
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
                          ),
                          // ElevatedButton(
                          //     onPressed: () {}, child: Text("Print date"))
                        ],
                      );
                  }
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text("No Data Available"),
                  );
                } else {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
              }),
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
