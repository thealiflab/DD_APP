import "package:flutter/material.dart";
import 'profile_pic.dart';
import 'profile_info_panel.dart';
import 'package:dd_app/api/user_info_api.dart';

class Profile extends StatefulWidget {
  static const String id = "profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<dynamic> apiData;
  UserInfoAPI userInfoAPI = new UserInfoAPI();

  @override
  void initState() {
    apiData = userInfoAPI.getUData();
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
          child: FutureBuilder<dynamic>(
            future: userInfoAPI.getUData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ProfilePic(
                      imageURL: snapshot.data['data']['user_profile_image']
                              .toString() ??
                          null,
                    ),
                    SizedBox(height: 20),
                    ProfileInfoPanel(
                      textIcon: Icons.account_circle,
                      info: snapshot.data['data']['user_fullname'].toString() ??
                          "No Data", //null-safety assurance
                    ),
                    ProfileInfoPanel(
                      textIcon: Icons.lock,
                      info:
                          snapshot.data['data']['user_unique_id'].toString() ??
                              "No Data",
                    ),
                    ProfileInfoPanel(
                      textIcon: Icons.phone,
                      info: snapshot.data['data']['user_phone'].toString() ??
                          "No Data",
                    ),
                    ProfileInfoPanel(
                      textIcon: Icons.email,
                      info: snapshot.data['data']['user_email'].toString() ??
                          "No Data",
                    ),
                    ProfileInfoPanel(
                      textIcon: Icons.security,
                      info: "Change Password",
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
