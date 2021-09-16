import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/utilities/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences localStorage;

class ClaimDiscountApi {
  Future<ClaimDiscountResponse> claim(
      ClaimDiscountRequest claimDiscountRequest) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        Uri.parse(baseUrl + claimDiscountExt),
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
        body: claimDiscountRequest.toJson(),
      );
      print(response);
      if (response.body != null) {
        return ClaimDiscountResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      throw Exception('Failed to load Data');
    }
  }

  //Claim by Vendor ID
  Future claimById(String vendorID) async {
    localStorage = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        Uri.parse(baseUrl + claimDiscountExt),
        headers: <String, String>{
          'Authorization': 'Bearer ${localStorage.get('Authorization')}',
          'Customer-ID': '${localStorage.get('Customer-ID')}',
        },
        body: {'vendorUniqueId': vendorID},
      );
      print(response);
      if (response.body != null) {
        return ClaimDiscountResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Data');
      }
    } catch (e) {
      throw Exception('Failed to load Data');
    }
  }
}

class ClaimDiscountResponse {
  final String message;
  final bool status;

  ClaimDiscountResponse({
    this.message,
    this.status,
  });
  factory ClaimDiscountResponse.fromJson(Map<String, dynamic> json) {
    return ClaimDiscountResponse(
      message: json["message"] != null ? json["message"] : "",
      status: json["status"] != null ? json["status"] : "",
    );
  }
}

class ClaimDiscountRequest {
  String vendorUniqueId;

  ClaimDiscountRequest({
    this.vendorUniqueId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'vendorUniqueId': vendorUniqueId,
    };
    return map;
  }
}
