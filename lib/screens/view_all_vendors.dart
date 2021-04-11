import 'package:dd_app/api/all_vendors_api.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/vendor_card.dart';

class ViewAllVendors extends StatefulWidget {
  static const String id = "view_all_vendors";

  @override
  _ViewAllVendorsState createState() => _ViewAllVendorsState();
}

class _ViewAllVendorsState extends State<ViewAllVendors> {
  //For API Call
  Future<dynamic> allVendorsApiData;
  AllVendorsAPI allVendorsAPI = AllVendorsAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Vendors',
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
          future: allVendorsAPI.getAVData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  itemCount: snapshot.data['data'].length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return VendorDetails(
                        context: context, snapshot: snapshot, index: index);
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
