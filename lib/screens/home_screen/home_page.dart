import 'package:dd_app/api/top_vendors_api.dart';
import 'package:dd_app/screens/about_us.dart';
import 'package:dd_app/screens/discount_history.dart';
import 'package:dd_app/screens/search/search_bar_panel.dart';
import 'package:dd_app/screens/payment_history.dart';
import 'package:dd_app/screens/payment_screen.dart';
import 'package:dd_app/screens/view_all_vendors.dart';
import 'package:dd_app/screens/login_register.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/utilities/services.dart';
import 'package:dd_app/screens/profile_screen/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_per_user.dart';
import 'open_qr_scanner.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../search/search_bar_page.dart';
import 'categories_panels.dart';
import 'package:dd_app/api/logout_api.dart';
import 'package:dd_app/utilities/vendor_card.dart';
import 'package:dd_app/globals.dart' as global;
import 'package:flutter/services.dart';
// ignore: implementation_imports
import 'package:flutter/src/painting/binding.dart';

//SharedPreferences
SharedPreferences localStorage;

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Pull Down Refresher
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomePage(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  //For API Call object initialize
  UserInfoAPI userInfoAPI;
  TopVendorsAPI topVendorsAPI;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  //For Logout API Call
  bool showProgress = false;
  LogoutResponse logoutResponse;
  LogoutAPI apiService = LogoutAPI();

  int _bottomNavigationBarIndex = 0;

  String _accountType;

  Future sharedPrefFunc() async {
    localStorage = await SharedPreferences.getInstance();
    _accountType = localStorage.getString("accountType");
  }

  //To exit the app when system back button pressed
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit DD Travel App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    userInfoAPI = UserInfoAPI();
    topVendorsAPI = TopVendorsAPI();
    if (global.isNewImageUploaded) {
      imageCache.clear();
      imageCache.clearLiveImages();
    } else {
      global.isNewImageUploaded = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sharedPrefFunc(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            key: _scaffoldKey,
            endDrawer: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(35),
                bottomLeft: Radius.circular(35),
              ),
              child: Drawer(
                child: _accountType == "Guest"
                    ? ListView(
                        children: <Widget>[
                          DrawerPerUser(
                            imageURL: null,
                            name: 'Guest User',
                          ), //DrawerHeader
                          ListTile(
                            leading: Icon(
                              Icons.description,
                              color: kPrimaryColor,
                            ),
                            title: Text('Blog'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.help_outline,
                              color: kPrimaryColor,
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
                              Icons.login,
                              color: kPrimaryColor,
                            ),
                            title: Text('Sign Up'),
                            onTap: () async {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginRegister(),
                                ),
                                (Route route) => false,
                              );
                            },
                          ),
                        ],
                      )
                    : FutureBuilder<dynamic>(
                        future: userInfoAPI.getUData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                              children: <Widget>[
                                DrawerPerUser(
                                  imageURL: snapshot.data['data']
                                              ['user_profile_image']
                                          .toString() ??
                                      null,
                                  name: snapshot.data['data']['user_fullname']
                                          .toString() ??
                                      'Guest User',
                                ), //DrawerHeader
                                ListTile(
                                  leading: Icon(
                                    Icons.person,
                                    color: kPrimaryColor,
                                  ),
                                  title: Text('Profile'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Profile(),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.description,
                                    color: kPrimaryColor,
                                  ),
                                  title: Text('Blog'),
                                  onTap: () {},
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.payments,
                                    color: kPrimaryColor,
                                  ),
                                  title: Text('Payment'),
                                  onTap: () {
                                    Navigator.pushNamed(context, Payment.id);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.history,
                                    color: kPrimaryColor,
                                  ),
                                  title: Text('Payment History'),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PaymentHistory.id);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.redeem,
                                    color: kPrimaryColor,
                                  ),
                                  title: Text('Discount History'),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, DiscountHistory.id);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.help_outline,
                                    color: kPrimaryColor,
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
                                    color: kPrimaryColor,
                                  ),
                                  title: Text('Logout'),
                                  onTap: () async {
                                    setState(() {
                                      showProgress = true;
                                    });
                                    apiService
                                        .postLogoutResponse(logoutResponse)
                                        .then((value) {
                                      setState(() {
                                        showProgress = false;
                                      });
                                      localStorage.remove("phone");
                                      if (value.status) {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginRegister(),
                                          ),
                                          (Route route) => false,
                                        );
                                      } else {
                                        print('Logout API not called properly');
                                        print(value.message);
                                      }
                                    });
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
              selectedLabelStyle: bottomNavigationBarButtonLabelStyle,
              unselectedLabelStyle: bottomNavigationBarButtonLabelStyle,
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
                  icon: Icon(
                    Icons.home,
                    color: kPrimaryColor,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.camera,
                    color: kPrimaryColor,
                  ),
                  label: 'Scan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    color: kPrimaryColor,
                  ),
                  label: 'Menu',
                ),
              ],
            ),
            body: showProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _accountType == "Guest"
                    ? SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: false,
                        header: WaterDropMaterialHeader(),
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
                                  horizontal: 25, vertical: 38),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      backgroundImage: AssetImage(
                                          'assets/images/homepage/profile.jpg'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 3.0),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, SearchBarPage.id,
                                    arguments: {'accountType': _accountType});
                              },
                              child: SearchBarPanel(),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Categories',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 7),
                                scrollDirection: Axis.horizontal,
                                itemCount: services.length,
                                itemBuilder: (BuildContext context, index) {
                                  return CategoriesPanels(
                                    indexNo: index,
                                    accountType: _accountType,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Popular Discount Deals',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, ViewAllVendors.id, arguments: {
                                      'accountType': _accountType
                                    }),
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.white),
                                    ),
                                    child: Text(
                                      'view all',
                                      style: TextStyle(
                                          fontSize: 18.0, color: kPrimaryColor),
                                    ),
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
                            SingleChildScrollView(
                              child: FutureBuilder<dynamic>(
                                future: topVendorsAPI.getVData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.all(12),
                                        itemCount: snapshot.data['data'].length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return VendorCard(
                                            context: context,
                                            snapshot: snapshot,
                                            index: index,
                                            accountType: _accountType,
                                          );
                                        });
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : FutureBuilder<dynamic>(
                        future: userInfoAPI.getUData(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            // ignore: missing_return
                            return SmartRefresher(
                              enablePullDown: true,
                              enablePullUp: false,
                              header: WaterDropMaterialHeader(),
                              footer: CustomFooter(
                                builder:
                                    (BuildContext context, LoadStatus mode) {
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
                                        horizontal: 25, vertical: 38),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              snapshot.data['data']
                                                          ['user_fullname']
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
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  offset: Offset(0.0, 4),
                                                  blurRadius: 10.0)
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: snapshot
                                                        .data['data'][
                                                            'user_profile_image']
                                                        .toString() !=
                                                    null
                                                ? NetworkImage(
                                                    baseUrl +
                                                        "/" +
                                                        snapshot.data['data'][
                                                                'user_profile_image']
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
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SearchBarPage.id,
                                          arguments: {
                                            'accountType': _accountType
                                          });
                                    },
                                    child: SearchBarPanel(),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Categories',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0),
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: services.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return CategoriesPanels(
                                          indexNo: index,
                                          accountType: _accountType,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Popular Discount Deals',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pushNamed(
                                              context, ViewAllVendors.id,
                                              arguments: {
                                                'accountType': _accountType
                                              }),
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          child: Text(
                                            'view all',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: kPrimaryColor),
                                          ),
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
                                  SingleChildScrollView(
                                    child: FutureBuilder<dynamic>(
                                      future: topVendorsAPI.getVData(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.all(12),
                                              itemCount:
                                                  snapshot.data['data'].length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return VendorCard(
                                                  context: context,
                                                  snapshot: snapshot,
                                                  index: index,
                                                  accountType: _accountType,
                                                );
                                              });
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
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
          ),
        );
      },
    );
  }
}
