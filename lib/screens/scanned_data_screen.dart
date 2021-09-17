import 'package:dd_app/api/claim_discount_api.dart';
import 'package:dd_app/screens/home_screen/home_page.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
import 'package:flutter/material.dart';

class ScannedData extends StatefulWidget {
  static const String id = "scanned_data";
  @override
  _ScannedDataState createState() => _ScannedDataState();
}

class _ScannedDataState extends State<ScannedData> {
  @override
  Widget build(BuildContext context) {
    final ReceiveDataClass receivedData =
        ModalRoute.of(context).settings.arguments;
    //final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scanned Data",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Scanned Data:\n",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text("${receivedData.barCodeString}"),
            Text(
              receivedData.barCodeString != null
                  ? receivedData.barCodeString
                  : "Please try manually from the login portal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Claim"))
          ],
        ),
      ),
    );
  }
}

class ReceiveDataClass {
  final String barCodeString;

  ReceiveDataClass(this.barCodeString);
}
