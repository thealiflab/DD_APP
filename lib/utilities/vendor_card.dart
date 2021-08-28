import 'dart:math';
import 'package:dd_app/screens/authentication/login_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/utilities/api_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dd_app/utilities/claim_now_alert_dialog.dart';

class VendorCard extends StatefulWidget {
  final BuildContext context;
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final String accountType;
  const VendorCard(
      {@required this.context,
      @required this.snapshot,
      @required this.index,
      @required this.accountType});

  @override
  _VendorCardState createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Location Permission'),
                content: Text(
                    'This app needs location access to calculate the distance'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  _dial(String phoneNumber) async {
    var dial = 'tel:$phoneNumber';
    if (await canLaunch(dial)) {
      await launch(dial);
    } else {
      throw 'Could not launch $dial';
    }
  }

  launchMap(lat, lng) async {
    String homeLat = lat.toString() ?? "37.3230";
    String homeLng = lng.toString() ?? "122.0312";

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }

  _email(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

  _gotoWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: GestureDetector(
            onTap: () {
              if (widget.accountType == "Guest") {
                Navigator.pushNamed(context, LoginRegister.id);
              } else {
                _determinePosition().then((position) async {
                  print(position);
                  if (widget.snapshot.data['data'][widget.index]
                              ['vendor_latitude'] !=
                          null ||
                      widget.snapshot.data['data'][widget.index]
                              ['vendor_latitude'] !=
                          "") {
                    print(widget.snapshot.data['data'][widget.index]
                        ['vendor_latitude']);
                    print(widget.snapshot.data['data'][widget.index]
                        ['vendor_longitude']);
                    double distanceInMeters = Geolocator.distanceBetween(
                        position.latitude,
                        position.longitude,
                        double.parse(widget.snapshot.data['data'][widget.index]
                            ['vendor_latitude']),
                        double.parse(widget.snapshot.data['data'][widget.index]
                            ['vendor_longitude']));
                    print(distanceInMeters);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return claimNowAlertDialog(widget.snapshot,
                              distanceInMeters, widget.index, context);
                        });
                  } else {
                    print("No Location Available");
                  }
                });
              }
            },
            child: Container(
              height: 125,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 4.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: Container(
                height: 125,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 115,
                      width: 122,
                      child: widget
                                  .snapshot
                                  .data['data'][widget.index]
                                      ['vendor_profile_image']
                                  .toString() !=
                              null
                          ? Image.network(
                              baseUrl +
                                  "/" +
                                  widget
                                      .snapshot
                                      .data['data'][widget.index]
                                          ['vendor_profile_image']
                                      .toString(),
                              fit: BoxFit.contain,
                              height: 115,
                              width: 122,
                            )
                          : Image.asset(
                              "assets/images/homepage/1.jpg",
                              fit: BoxFit.contain,
                              height: 115,
                              width: 122,
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.snapshot
                                    .data['data'][widget.index]['vendor_name']
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.snapshot
                                  .data['data'][widget.index]['location_name']
                                  .toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Discount ${widget.snapshot.data['data'][widget.index]['discount_amount']}%",
                              style:
                                  TextStyle(fontSize: 16, color: kPrimaryColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launchMap(
                                        widget.snapshot.data['data']
                                                    [widget.index]
                                                ['vendor_latitude'] ??
                                            "37.3230",
                                        widget.snapshot.data['data']
                                                    [widget.index]
                                                ['vendor_longitude'] ??
                                            "122.0312",
                                      );
                                    },
                                    child: Icon(
                                      Icons.location_on,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _dial(widget
                                          .snapshot
                                          .data['data'][widget.index]
                                              ['vendor_phone']
                                          .toString());
                                    },
                                    child: Icon(
                                      Icons.phone_android_rounded,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _gotoWeb(widget
                                          .snapshot
                                          .data['data'][widget.index]
                                              ['vendor_website']
                                          .toString());
                                    },
                                    child: Icon(
                                      Icons.public_rounded,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _gotoWeb(widget
                                          .snapshot
                                          .data['data'][widget.index]
                                              ['vendor_facebook']
                                          .toString());
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/facebook.svg',
                                      width: 20,
                                      height: 20,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: pi / -2,
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: kPrimaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15.0,
                              offset: Offset(2.0, 4.4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Claim',
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: .2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
