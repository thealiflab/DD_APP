import 'package:dd_app/api/claim_discount_api.dart';
import 'package:dd_app/screens/scanned_data_screen.dart';
import 'package:dd_app/utilities/snack_bar_message.dart';
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
                    print("Unique Id ${scanData.code}");
                    List vendorUniqueID = scanData.code.split('"');
                    print(vendorUniqueID[3]);
                    ClaimDiscountRequest().vendorUniqueId = vendorUniqueID[3];

                    ClaimDiscountApi apiCL = ClaimDiscountApi();
                    apiCL.claimById(vendorUniqueID[3]).then((value) {
                      if (value.status) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarMessage(
                            value.message.toString(),
                            true,
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarMessage(
                            value.message.toString(),
                            false,
                          ),
                        );
                      }
                    });
                    // Navigator.pushNamed(
                    //   context,
                    //   ScannedData.id,
                    //   arguments: ReceiveDataClass(vendorUniqueID[3]),
                    // );
                  }
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
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
