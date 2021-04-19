import 'package:dd_app/screens/home_screen/home_page.dart';
import "package:flutter/material.dart";

class Blog extends StatelessWidget {
  static const String id = "blog";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, HomePage.id),
        ),
        title: Text("Blog"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "No Data",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
