import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';

class LoginService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/login"),
      body: requestModel.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}

class LoginResponseModel {
  final String token;
  final String CI;
  final String message;
  final bool status;

  LoginResponseModel({
    this.token,
    this.CI,
    this.message,
    this.status,
  });
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      CI: json["Customer-ID"] != null ? json["Customer-ID"] : "",
      message: json["message"] != null ? json["message"] : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}

class LoginRequestModel {
  String phone;
  String password;

  LoginRequestModel({
    this.phone,
    this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone.trim(),
      'password': password.trim()
    };

    return map;
  }
}
