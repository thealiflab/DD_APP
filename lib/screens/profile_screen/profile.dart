import "package:flutter/material.dart";
import 'profile_pic.dart';
import 'profile_info_panel.dart';

class Profile extends StatefulWidget {
  static const String id = "profile";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
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
                info: "Mr Ahmed",
              ),
              ProfileInfoPanel(
                textIcon: Icons.lock,
                info: "2102-1001-SELK27",
              ),
              ProfileInfoPanel(
                textIcon: Icons.phone,
                info: "01712121212",
              ),
              ProfileInfoPanel(
                textIcon: Icons.email,
                info: "support@dd.limited",
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
