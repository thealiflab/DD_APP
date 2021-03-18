import 'package:dd_app/model/customer_info_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'global_ref_values.dart' as ref;

class CustomerInfo {
  Future<CustomerResponseModel> getData() async {
    const baseUrl = "https://apps.dd.limited";

    final response = await http.get(
      "$baseUrl/api/v1/customer/update",
      headers: <String, String>{
        "Accept": "application/json",
        'Authorization': 'Bearer ${ref.token}',
        'Customer-ID': '${ref.CI}',
      },
    );

    print("this is customerData = ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 400) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
