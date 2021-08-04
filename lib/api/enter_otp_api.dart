import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class EnterOTPApi {
  Future<EnterOTPResponse> login(OTPRequest requestModel) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      if (localStorage.getBool("resetPassword")) {
        final response = await http.post(
          Uri.parse(baseUrl + forgetPasswordExt),
          headers: <String, String>{
            'State': 'Second',
          },
          body: requestModel.toJson(),
        );

        if (response.statusCode == 200 || response.statusCode == 400) {
          return EnterOTPResponse.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load Data, API calling Failed!');
        }
      } else {
        final response = await http.post(
          Uri.parse(baseUrl + registerExt),
          headers: <String, String>{
            'State': 'Second',
          },
          body: requestModel.toJson(),
        );

        if (response.statusCode == 200 || response.statusCode == 400) {
          return EnterOTPResponse.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load Data, API calling Failed!');
        }
      }
    } catch (e) {
      throw Exception("Exception Caught which is " + e);
    }
  }
}

class EnterOTPResponse {
  final String token;
  final String CI;
  final String message;
  final bool status;

  EnterOTPResponse({
    this.token,
    this.CI,
    this.message,
    this.status,
  });
  factory EnterOTPResponse.fromJson(Map<String, dynamic> json) {
    return EnterOTPResponse(
      token: json["token"] != null ? json["token"] : "",
      CI: json["Customer-ID"] != null ? json["Customer-ID"] : "",
      message: json["message"] != null ? json["message"] : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}

class OTPRequest {
  String phone;
  String otp;

  OTPRequest({this.phone, this.otp});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone,
      'OTP': otp,
    };
    return map;
  }
}
