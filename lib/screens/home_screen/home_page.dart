import 'package:dd_app/screens/about_us.dart';
import 'package:dd_app/screens/air_only.dart';
import 'package:dd_app/screens/bus_only.dart';
import 'package:dd_app/screens/helicopter_only.dart';
import 'package:dd_app/screens/hotel_only.dart';
import 'package:dd_app/screens/restaurant_only.dart';
import 'package:flutter/material.dart';
import 'package:dd_app/components/popular_deals.dart';
import 'package:dd_app/components/services.dart';
import 'package:dd_app/screens/profile_screen/profile.dart';
import 'package:dd_app/screens/about_us.dart';
import 'drawer_per_user.dart';
import 'package:dd_app/model/customer_info_model.dart';
import 'package:dd_app/api/customer_api.dart';
import 'package:dd_app/screens/share_your_location.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  int _bottomNavigationBarIndex = 0;

  CustomerInfo customerData;

  @override
  void initState() {
    super.initState();
    customerData = new CustomerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35), bottomLeft: Radius.circular(35)),
        child: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerPerUser(),
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
                  // Navigator.pushNamed(context, '/transactionsList');
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
                          builder: (BuildContext context) => AboutUs()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                ),
                title: Text('Logout'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ShareYourLocation()));
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavigationBarIndex,
        onTap: (value) {
          if (value == 2) {
            _openEndDrawer();
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hello,',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "User",
                      //TODO fix this
                      // '${customerData.getData()}',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/homepage/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4),
                          blurRadius: 10.0)
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.0),
          //window for search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 10.0),
                      blurRadius: 10.0)
                ],
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.search,
                      size: 30.0,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.79,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Your Deals',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          //popular hotel
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
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
            height: 12,
          ),
          Container(
            height: 120,
            width: double.infinity,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: () {
                    var onTapService = services[index].title;

                    switch (onTapService) {
                      case 'Hotel':
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotelOnly()),
                          );
                        }
                        break;

                      case 'Restaurant':
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RestaurantOnly()),
                          );
                        }
                        break;

                      case 'Air Ticket':
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AirOnly()),
                          );
                        }
                        break;

                      case 'Bus Ticket':
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BusOnly()),
                          );
                        }
                        break;

                      case 'Helicopter':
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelicopterOnly()),
                          );
                        }
                        break;
                    }
                  },
                  highlightColor: Color(0xFF24b5c4),
                  splashColor: Color(0xFF24b5c4),
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
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Icon(
                                services[index].icon,
                                color: Color(0xFF24b5c4),
                                size: 30.0,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Center(
                              child: Text(
                                services[index].title,
                                style: TextStyle(fontSize: 16.0),
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
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
                Text(
                  'view all',
                  style: TextStyle(fontSize: 18.0, color: Color(0xFF24b5c4)),
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
          Column(
            children: <Widget>[
              _hotelPackage(0),
              SizedBox(height: 20),
              _hotelPackage(1),
              SizedBox(height: 20),
              _hotelPackage(2),
              SizedBox(height: 20),
              _hotelPackage(4),
              SizedBox(height: 20),
              _hotelPackage(1),
            ],
          )
        ],
      ),
    );
  }
}

_hotelPackage(int index) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Container(
      height: 130,
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
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              height: 130,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: AssetImage(hotels[index].imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  hotels[index].title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  hotels[index].description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '\$${hotels[index].discount} %',
                  style: TextStyle(fontSize: 16, color: Color(0xFF24b5c4)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.directions_car,
                        color: Color(0xFF24b5c4),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.hot_tub,
                        color: Color(0xFF24b5c4),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.local_bar,
                        color: Color(0xFF24b5c4),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.wifi,
                        color: Color(0xFF24b5c4),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 300,
            child: Center(
              child: Transform.rotate(
                angle: 3.14159 / -2,
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF24b5c4),
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
                      'Claim Now',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: .2),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
