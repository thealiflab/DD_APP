import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class LogoutAPI {
  Future<LogoutResponse> postLogoutResponse(
      LogoutResponse logoutResponse) async {
    localStorage = await SharedPreferences.getInstance();
    print(localStorage != null ? true : false);
    print(localStorage.get('Authorization'));

    try {
      http.Response response = await http.post(
        "$baseUrl/api/v1/logout",
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return LogoutResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      throw Exception("Exception Caught which is " + e);
    }
  }
}

class LogoutResponse {
  bool status;
  String message;

  LogoutResponse({this.status, this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      status: json["status"] != null ? json["status"] : "",
      message: json["message"] != null ? json["message"] : "",
    );
  }
}
