import 'package:flutter/material.dart';
import 'package:dd_app/utilities/services.dart';
import 'package:dd_app/utilities/constants.dart';
import 'package:dd_app/screens/category_page.dart';

class CategoriesPanels extends StatelessWidget {
  final int indexNo;
  final String accountType;
  CategoriesPanels({@required this.indexNo, @required this.accountType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var onTapService = services[indexNo].title;

        switch (onTapService) {
          case 'Hotel':
            {
              Navigator.pushNamed(
                context,
                CategoryPage.id,
                arguments: {
                  'service_name': onTapService,
                  'id': '1',
                  'accountType': accountType
                },
              );
            }
            break;

          case 'Restaurant':
            {
              Navigator.pushNamed(
                context,
                CategoryPage.id,
                arguments: {
                  'service_name': onTapService,
                  'id': '2',
                  'accountType': accountType
                },
              );
            }
            break;

          case 'Air Ticket':
            {
              Navigator.pushNamed(
                context,
                CategoryPage.id,
                arguments: {
                  'service_name': onTapService,
                  'id': '4',
                  'accountType': accountType
                },
              );
            }
            break;

          case 'Bus Ticket':
            {
              Navigator.pushNamed(
                context,
                CategoryPage.id,
                arguments: {
                  'service_name': onTapService,
                  'id': '3',
                  'accountType': accountType
                },
              );
            }
            break;

          case 'Aviation':
            {
              Navigator.pushNamed(
                context,
                CategoryPage.id,
                arguments: {
                  'service_name': onTapService,
                  'id': '5',
                  'accountType': accountType
                },
              );
            }
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
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                Center(
                  child: Icon(
                    services[indexNo].icon,
                    color: kPrimaryColor,
                    size: 30.0,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    services[indexNo].title,
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
  }
}
