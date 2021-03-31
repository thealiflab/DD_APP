import 'package:dd_app/screens/discounts.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class OpenQRScanner extends StatefulWidget {
  static const String id = "open_qr_scanner";

  @override
  _OpenQRScannerState createState() => _OpenQRScannerState();
}

class _OpenQRScannerState extends State<OpenQRScanner> {
  final GlobalKey qrKey = GlobalKey();
  Barcode qrText;
  //var qrText = "";
  QRViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: QRView(
              overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Color(0xFF24b5c4),
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this._controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  if (mounted) {
                    _controller.dispose();
                    Navigator.pushNamed(
                      context,
                      Discounts.id,
                      arguments: ReceiveDataClass(scanData.code),
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  //for disposing QR Scanner
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
