import 'package:dd_app/api/vendor_info_api.dart';
import 'package:dd_app/screens/about_us.dart';
import 'package:dd_app/screens/air_only.dart';
import 'package:dd_app/screens/bus_only.dart';
import 'package:dd_app/screens/aviation_only.dart';
import 'package:dd_app/screens/hotel_only.dart';
import 'package:dd_app/screens/login_register.dart';
import 'package:dd_app/screens/restaurant_only.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/popular_deals.dart';
import 'package:dd_app/utilities/services.dart';
import 'package:dd_app/screens/profile_screen/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_per_user.dart';
import 'package:dd_app/screens/share_your_location.dart';
import 'open_qr_scanner.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:dd_app/api/vendor_info_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'search_bar.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Pull Down Refresher
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  //For API Call
  Future<dynamic> userApiData;
  Future<dynamic> vendorApiData;

  UserInfoAPI userInfoAPI = UserInfoAPI();
  VendorInfoAPI vendorInfoAPI = VendorInfoAPI();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  int _bottomNavigationBarIndex = 0;

  @override
  void initState() {
    userApiData = userInfoAPI.getUData();
    vendorApiData = vendorInfoAPI.getVData();
    print("printing apiData $userApiData");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
        child: Drawer(
          child: FutureBuilder<dynamic>(
              future: userInfoAPI.getUData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: <Widget>[
                      DrawerPerUser(
                        imageURL: snapshot.data['data']['user_profile_image']
                                .toString() ??
                            null,
                        name:
                            snapshot.data['data']['user_fullname'].toString() ??
                                'Guest User',
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                        ),
                        title: Text('Profile'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Profile(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.description,
                        ),
                        title: Text('Blog'),
                        onTap: () {
// Navigator.pushNamed(context, '/home');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.payments,
                        ),
                        title: Text('Subscription'),
                        onTap: () {
// Navigator.pushNamed(context, '/transactionsList');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.history,
                        ),
                        title: Text('Payment History'),
                        onTap: () {
// Navigator.pushNamed(context, '/transactionsList');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.redeem,
                        ),
                        title: Text('Discounts'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OpenQRScanner()));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.help_outline,
                        ),
                        title: Text('About Us'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AboutUs()));
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                        ),
                        //TODO Logout api call from here
                        title: Text('Logout'),
                        onTap: () async {
                          SharedPreferences localStorage =
                              await SharedPreferences.getInstance();
                          localStorage.remove("phone");
                          Navigator.pushNamed(context, LoginRegister.id);
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavigationBarIndex,
        onTap: (value) {
          if (value == 2) {
            _openEndDrawer(); // To open right side drawer
          }
          if (value == 1) {
            Navigator.pushNamed(context, OpenQRScanner.id);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: userInfoAPI.getUData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print("this is snapshot values below");
            print(snapshot.data['data']['user_fullname'].toString());
            // ignore: missing_return
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Hello,',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              snapshot.data['data']['user_fullname']
                                      .toString() ??
                                  "Guest User",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0.0, 4),
                                  blurRadius: 10.0)
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage: snapshot.data['data']
                                            ['user_profile_image']
                                        .toString() !=
                                    null
                                ? NetworkImage(
                                    baseUrl +
                                        "/" +
                                        snapshot.data['data']
                                                ['user_profile_image']
                                            .toString(),
                                  )
                                : AssetImage(
                                    'assets/images/homepage/profile.jpg'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 3.0),
//window for search
                  SearchBar(),
//popular hotel
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20.0),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 2,
                    indent: 22,
                    endIndent: 50,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 120,
                    width: double.infinity,
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      scrollDirection: Axis.horizontal,
                      itemCount: services.length,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            var onTapService = services[index].title;

                            switch (onTapService) {
                              case 'Hotel':
                                // {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HotelOnly()),
                                //   );
                                // }
                                break;

                              case 'Restaurant':
                                // {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => RestaurantOnly()),
                                //   );
                                // }
                                break;

                              case 'Air Ticket':
                                // {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AirOnly()),
                                //   );
                                // }
                                break;

                              case 'Bus Ticket':
                                // {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => BusOnly()),
                                //   );
                                // }
                                break;

                              case 'Helicopter':
                                // {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HelicopterOnly()),
                                //   );
                                // }
                                break;
                            }
                          },
                          splashColor: kPrimaryColor,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 4.0),
                                  blurRadius: 10.0,
                                )
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Icon(
                                        services[index].icon,
                                        color: kPrimaryColor,
                                        size: 30.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        services[index].title,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Popular Discount Deals',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'view all',
                          style:
                              TextStyle(fontSize: 18.0, color: kPrimaryColor),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 2,
                    indent: 22,
                    endIndent: 50,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  SingleChildScrollView(
                    child: FutureBuilder<dynamic>(
                      future: vendorInfoAPI.getVData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(12),
                              itemCount: snapshot.data['data'].length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                //_countryName(snapshot.data[index]),
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Container(
                                        height: 115,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                          height: 115,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 115,
                                                width: 122,
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/homepage/6.jpg'),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snapshot.data['data']
                                                                [index]
                                                                ['vendor_name']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        snapshot.data['data']
                                                                [index][
                                                                'vendor_full_address']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        '15 %',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                kPrimaryColor),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        snapshot.data['data']
                                                                [index]
                                                                ['vendor_phone']
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 11.0,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              });
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
