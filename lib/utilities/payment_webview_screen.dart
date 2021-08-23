import 'dart:async';
import 'dart:io';

import 'package:dd_app/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebview extends StatefulWidget {
  static const String id = "ssl_payment";

  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Payment',
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
                Navigator.pushNamed(context, Payment.id);
              },
            ),
          ),
          body: Container(
            height: _height,
            width: _width,
            child: WebView(
              initialUrl: arguments["paymentUrl"],
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController.complete(webViewController);
              },
            ),
          ),
        ));
  }
}
