import 'package:dd_app/api/category_vendors_api.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/screens/home_screen/vendor_card.dart';
import 'package:dd_app/screens/home_screen/claim_now.dart';

class CategoryPage extends StatefulWidget {
  static const String id = "category_page";

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  //For API Call
  CategoryVendorsAPI categoryVendorsAPI = CategoryVendorsAPI();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          arguments['service_name'],
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
      body: SingleChildScrollView(
        child: FutureBuilder<dynamic>(
          future: categoryVendorsAPI.getAVData(arguments['id']),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['status'].toString() == "true") {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  itemCount: snapshot.data['data'].length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Discount Claim",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: claimNow(snapshot, index),
                                  actions: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Claim Now",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: vendorCard(context, snapshot, index));
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "No Vendor Found",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
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
