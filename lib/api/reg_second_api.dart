import 'package:dd_app/model/register_second_otp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterServiceSecond {
  Future<RegisterSecondResponseModel> login(
      RegisterSecondRequestModel requestModel) async {
    const baseUrl = "https://apps.dd.limited";

    final response = await http.post(
      "$baseUrl/api/v1/customer/register",
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        'State': 'Second',
      },
      body: requestModel.toJson(),
    );
    //for testing
    print("This is request model below");
    print(requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterSecondResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
