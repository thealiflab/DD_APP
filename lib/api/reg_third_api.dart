import 'package:dd_app/model/register_third_details_update.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'global_ref_values.dart' as ref;

class RegisterServiceThird {
  Future<RegisterThirdResponseModel> login(
      RegisterThirdRequestModel requestModel) async {
    const baseUrl = "https://apps.dd.limited";

    final response = await http.post(
      "$baseUrl/api/v1/customer/update",
      headers: <String, String>{
        "Accept": "application/json",
        'Authorization': 'Bearer ${ref.token}',
        'Customer-ID': '${ref.CI}',
      },
      body: requestModel.toJson(),
    );
    //for testing
    print("This is request model below");
    print(requestModel.toJson());

    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterThirdResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
