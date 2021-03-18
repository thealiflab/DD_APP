import 'package:dd_app/model/register_first_phone.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterServiceFirst {
  Future<RegisterFirstResponseModel> login(
      RegisterFirstRequestModel requestModel) async {
    const baseUrl = "https://apps.dd.limited";

    final response = await http.post(
      "$baseUrl/api/v1/customer/register",
      headers: <String, String>{
        'State': 'First',
      },
      body: requestModel.toJson(),
    );
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterFirstResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
