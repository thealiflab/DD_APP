import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class GuestLoginAPI {
  Future<dynamic> getGData() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$baseUrl/api/v1/guest/login"),
        headers: <String, String>{
          'X-Guest': 'guestLogin',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      print("Exception Caught which is " + e);
    }
  }
}
