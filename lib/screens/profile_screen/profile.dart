import "package:flutter/material.dart";
import 'profile_pic.dart';
import 'profile_info_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';

SharedPreferences localStorage;

class Profile extends StatefulWidget {
  static const String id = "profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _name;
  String _uniqueID;
  String _phoneNumber;
  String _emailAddress;
  String _imageURL;

  Future getData() async {
    localStorage = await SharedPreferences.getInstance();
    print(localStorage != null ? true : false);
    print(localStorage.get('Authorization'));
    try {
      http.Response response = await http.get(
        "$baseUrl/api/v1/customer",
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.body.isNotEmpty) {
        print(response.body);
        setState(() {
          _name = data['data']['user_fullname'].toString();
          _uniqueID = data['data']['user_unique_id'].toString();
          _phoneNumber = data['data']['user_phone'].toString();
          _emailAddress = data['data']['user_email'].toString();
        });
      } else {
        print('Failed to load Data');
      }
    } catch (e) {
      print("Exception Caught which is " + e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: [
              ProfilePic(),
              SizedBox(height: 20),
              ProfileInfoPanel(
                textIcon: Icons.account_circle,
                info: _name ?? "No Data", //null-safety assurance
              ),
              ProfileInfoPanel(
                textIcon: Icons.lock,
                info: _uniqueID ?? "No Data",
              ),
              ProfileInfoPanel(
                textIcon: Icons.phone,
                info: _phoneNumber ?? "No Data",
              ),
              ProfileInfoPanel(
                textIcon: Icons.email,
                info: _emailAddress ?? "No Data",
              ),
              ProfileInfoPanel(
                textIcon: Icons.security,
                info: "Change Password",
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
