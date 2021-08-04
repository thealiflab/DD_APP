import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class RenewSubAPI {
//Get Request for Registration details
  Future getRegistrationFee() async {
    String url = baseUrl + registrationFeeExt;
    localStorage = await SharedPreferences.getInstance();
    String authorization = "Bearer ${localStorage.get('Authorization')}";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Customer-ID': '${localStorage.get('Customer-ID')}',
      "Authorization": authorization
    });
    print(
        '\nAPI Status Code an  body ${response.statusCode}\n API${json.decode(response.body)}');
    bool isSuccess = response.statusCode == 200;
    var data = json.decode(response.body);

    return {
      'isSuccess': isSuccess,
      "optionId": isSuccess ? data["data"]["option_id"] : null,
      "optionName": isSuccess ? data["data"]["option_name"] : null,
      "optionValue": isSuccess ? data["data"]["option_value"] : null,
      "error": isSuccess ? null : data['message'],
    };
  }

// <===================== Get Request for Subscription details
  Future getSubscriptionFee() async {
    String url = baseUrl + subscriptionFeeExt;
    localStorage = await SharedPreferences.getInstance();

    String authorization = "Bearer ${localStorage.get('Authorization')}";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Customer-ID': '${localStorage.get('Customer-ID')}',
      "Authorization": authorization
    });
    print(
        '\nAPI Status Code an  body ${response.statusCode}\n API${json.decode(response.body)}');
    bool isSuccess = response.statusCode == 200;
    var data = json.decode(response.body);

    return {
      'isSuccess': isSuccess,
      "optionId": isSuccess ? data["data"]["option_id"] : null,
      "optionName": isSuccess ? data["data"]["option_name"] : null,
      "optionValue": isSuccess ? data["data"]["option_value"] : null,
      "error": isSuccess ? null : data['message'],
    };
  }

  //  request for subscription
  Future<dynamic> getData(String month, String tID, String fee) async {
    localStorage = await SharedPreferences.getInstance();

    try {
      http.Response response = await http.get(
        Uri.parse(
            "$baseUrl$renewSubscriptionExt?subscription_limit=$month&transaction_id=$tID&subscription_fee=$fee"),
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
