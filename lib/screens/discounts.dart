import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Discounts extends StatefulWidget {
  static const String id = "discounts";
  @override
  _DiscountsState createState() => _DiscountsState();
}

class _DiscountsState extends State<Discounts> {
  @override
  Widget build(BuildContext context) {
    final ReceiveDataClass receivedData =
        ModalRoute.of(context).settings.arguments;
    //final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Discounts'),
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
            Text(
              receivedData.barCodeString != null
                  ? receivedData.barCodeString
                  : "Data",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
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
