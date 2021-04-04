import 'package:dd_app/api/category_vendors_api.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/screens/home_screen/vendor_card.dart';

class RestaurantOnly extends StatefulWidget {
  static const String id = "restaurant_only";

  @override
  _RestaurantOnlyState createState() => _RestaurantOnlyState();
}

class _RestaurantOnlyState extends State<RestaurantOnly> {
  //For API Call
  Future<dynamic> categoryVendorsApiData;
  CategoryVendorsAPI categoryVendorsAPI = CategoryVendorsAPI();

  @override
  void initState() {
    super.initState();
  }

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
                    return VendorCard(context, snapshot, index);
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
