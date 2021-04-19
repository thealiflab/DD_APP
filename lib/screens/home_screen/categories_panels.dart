import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/screens/category_page.dart';

class CategoriesPanels extends StatelessWidget {
  final String serviceName;
  final String serviceID;
  final String iconUnicode;
  final String accountType;
  CategoriesPanels(
      {@required this.serviceName,
      @required this.serviceID,
      @required this.iconUnicode,
      @required this.accountType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          CategoryPage.id,
          arguments: {
            'service_name': serviceName,
            'id': serviceID,
            'accountType': accountType
          },
        );
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
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Icon(
                      IconData(
                        int.parse('0x$iconUnicode'),
                        fontFamily: 'FontAwesomeSolid',
                        fontPackage: 'font_awesome_flutter',
                      ),
                      color: kPrimaryColor,
                      size: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      serviceName,
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
