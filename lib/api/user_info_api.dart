import 'package:dd_app/model/customer_info_model.dart';
import 'package:dd_app/screens/authentication/login_register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class UserInfoAPI {
  Future<dynamic> getUData(context) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      http.Response response = await http.get(
        Uri.parse(baseUrl + customerExt),
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
      );
      print("Status ${json.decode(response.body)["status"]}");
      if (json.decode(response.body)["status"] == true) {
        return json.decode(response.body);
      } else {
        localStorage.remove("phone");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginRegister(),
          ),
          (Route route) => false,
        );
      }
    } catch (e) {
      print("Exception Caught which is " + e);
    }
  }
// GET Method For User Information

  Future<CustomerInfoGetModel> getUserInfo() async {
    localStorage = await SharedPreferences.getInstance();
    var response = await http.get(
      Uri.parse(baseUrl + customerExt),
      headers: <String, String>{
        'Authorization': 'Bearer ${localStorage.get('Authorization')}',
        'Customer-ID': '${localStorage.get('Customer-ID')}',
      },
    );
    print('API ${response.statusCode}\n API${json.decode(response.body)}');
    if (response.statusCode == 200) {
      return CustomerInfoGetModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to load User Information');
    }
  }
}
