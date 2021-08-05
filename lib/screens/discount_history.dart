import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:dd_app/utilities/constants.dart';

class DiscountHistory extends StatefulWidget {
  static const String id = "discount_history";
  @override
  _DiscountHistoryState createState() => _DiscountHistoryState();
}

class _DiscountHistoryState extends State<DiscountHistory> {
  //For API Call
  UserInfoAPI userInfoAPI = UserInfoAPI();

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
          future: userInfoAPI.getUData(context),
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
                            Expanded(
                              child: Text(
                                snapshot.data['data']['claimHistory'][index]
                                        ['vendor_name'] ??
                                    "No data found",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                snapshot.data['data']['claimHistory'][index]
                                        ['date_time'] ??
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
                                snapshot.data['data']['claimHistory'][index]
                                        ['location_name'] ??
                                    "No data found",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                snapshot.data['data']['claimHistory'][index]
                                        ['discount_amount'] ??
                                    "No data found",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              snapshot.data['data']['claimHistory'][index]
                                      ['claim_via'] ??
                                  "No data found",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                snapshot.data['data']['claimHistory'][index]
                                        ['vendor_unique_id'] ??
                                    "No data found",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
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
