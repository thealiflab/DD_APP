import 'package:dd_app/api/discount_history_api.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscountHistory extends StatefulWidget {
  static const String id = "discount_history";
  @override
  _DiscountHistoryState createState() => _DiscountHistoryState();
}

class _DiscountHistoryState extends State<DiscountHistory> {
  //For API Call
  DiscountHistoryAPI discountHistoryAPI = DiscountHistoryAPI();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Discount History",
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
          future: discountHistoryAPI.getDiscountHistory(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  itemCount: snapshot.data['data']['claimHistory'].length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                child: Text(
                                  snapshot.data['data']['claimHistory'][index]
                                          ['vendor_name'] ??
                                      "No data found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      snapshot.data['data']['claimHistory']
                                              [index]['location_name'] ??
                                          "No data found",
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: kPrimaryColor,
                                        ),
                                        Text(
                                          snapshot.data['data']['claimHistory']
                                                  [index]['date_time'] ??
                                              "No data found",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "${snapshot.data['data']['claimHistory'][index]['discount_amount']}%" ??
                                        "No data found",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Discount",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: InkWell(
                                onTap: () {
                                  launch(
                                      "tel://${snapshot.data['data']['claimHistory'][index]['vendor_phone']}");
                                  print("object");
                                },
                                child: Container(
                                  width: _width / 2.3,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        snapshot.data['data']['claimHistory']
                                                [index]['vendor_phone'] ??
                                            "No data found",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
}
