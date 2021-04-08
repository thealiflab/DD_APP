import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class RenewSubAPI {
  Future<dynamic> getData(String month, String tID, String fee) async {
    localStorage = await SharedPreferences.getInstance();

    try {
      http.Response response = await http.get(
        "$baseUrl/api/v1/customer/renewSubscription?subscription_limit=$month&transaction_id=$tID&subscription_fee=$fee",
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
      );

      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (e) {
      print("Exception Caught which is " + e);
    }
  }
}
