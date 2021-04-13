import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class EnterPhoneApi {
  Future<EnterPhoneResponse> login(PhoneRequest requestModel) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      if (localStorage.getBool("resetPassword")) {
        final response = await http.post(
          Uri.parse("$baseUrl/api/v1/forgotPassword"),
          headers: <String, String>{
            'State': 'First',
          },
          body: requestModel.toJson(),
        );

        if (response.statusCode == 200 || response.statusCode == 400) {
          return EnterPhoneResponse.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load Data, API calling Failed!');
        }
      } else {
        final response = await http.post(
          Uri.parse("$baseUrl/api/v1/customer/register"),
          headers: <String, String>{
            'State': 'First',
          },
          body: requestModel.toJson(),
        );

        if (response.statusCode == 200 || response.statusCode == 400) {
          return EnterPhoneResponse.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load Data, API calling Failed!');
        }
      }
    } catch (e) {
      throw Exception("Exception Caught which is " + e);
    }
  }
}

//to get data from server through api
class EnterPhoneResponse {
  final bool status;
  final String message;

  EnterPhoneResponse({
    this.message,
    this.status,
  });
  factory EnterPhoneResponse.fromJson(Map<String, dynamic> json) {
    return EnterPhoneResponse(
      message: json["message"] != null ? json["message"] : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}

//to send data to the server
class PhoneRequest {
  String phone;

  PhoneRequest({
    this.phone,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone.trim(),
    };
    return map;
  }
}
