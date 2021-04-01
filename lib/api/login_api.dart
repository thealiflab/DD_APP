import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/constants.dart';

class LoginService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    final response = await http.post(
      "$baseUrl/api/v1/login",
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
  final String error;
  final String CI;

  LoginResponseModel({
    this.token,
    this.error,
    this.CI,
  });
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
      CI: json["Customer-ID"] != null ? json["Customer-ID"] : "",
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
