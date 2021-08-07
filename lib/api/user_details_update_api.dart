import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dd_app/utilities/api_constants.dart';

SharedPreferences localStorage;

class UserDetailsUpdate {
  Future<UpdateDetailsResponse> login(UpdateDetailsRequest requestModel) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        Uri.parse(baseUrl + userDetailsUpdateExt),
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
        body: requestModel.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        return UpdateDetailsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Data, API calling Failed!');
      }
    } catch (e) {
      throw AssertionError([print(e)]);
    }
  }
}

class UpdateDetailsResponse {
  final String message;
  final bool status;

  UpdateDetailsResponse({this.message, this.status});

  factory UpdateDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDetailsResponse(
      message: json["message"] != null ? json["message"] : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}

class UpdateDetailsRequest {
  String name;
  String email;
  String password;

  UpdateDetailsRequest({
    this.name,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    if (localStorage.getBool("resetPassword")) {
      Map<String, dynamic> map = {
        'password': password.trim(),
      };
      return map;
    } else {
      Map<String, dynamic> map = {
        'name': name ?? '',
        'email': email ?? '',
        'password': password ?? '',
      };
      return map;
    }
  }
}
