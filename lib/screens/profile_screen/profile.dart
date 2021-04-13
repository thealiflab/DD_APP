import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/screens/profile_screen/profile_edit_screen.dart';
import 'package:dd_app/utilities/action_button.dart';
import 'package:dd_app/utilities/constants.dart';
import "package:flutter/material.dart";
import 'profile_pic.dart';
import 'profile_info_panel.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class Profile extends StatefulWidget {
  static const String id = "profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<dynamic> apiData;
  UserInfoAPI userInfoAPI = new UserInfoAPI();

  Future sharedPrefFunc() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    apiData = userInfoAPI.getUData();
    sharedPrefFunc();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, HomePage.id),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    ActionButton(
                        buttonColor: kPrimaryColor,
                        buttonText: "Update Info",
                        onTap: () {
                          localStorage.setBool("resetPassword", false);
                          Navigator.pushNamed(context, ProfileEdit.id);
                        },
                        textColor: Colors.white),
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
