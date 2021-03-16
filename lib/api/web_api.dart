import 'package:dd_app/model/login_user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    //String url = "https://reqres.in/api/login";
    String url = "https://apps.dd.limited/api/v1/login";

    final response = await http.post(
      url,
      body: requestModel.toJson(),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
