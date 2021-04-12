import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class TopVendorsAPI {
  Future<dynamic> getVData() async {
    localStorage = await SharedPreferences.getInstance();
    print(localStorage != null ? true : false);
    print(localStorage.get('Authorization'));

    try {
      http.Response response = await http.get(
        "$baseUrl/api/v1/globals/topVendors",
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      print("Exception Caught which is " + e);
    }
  }
}
