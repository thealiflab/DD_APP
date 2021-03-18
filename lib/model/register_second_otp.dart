class RegisterSecondResponseModel {
  final String token;
  final String error;
  final String CI;

  RegisterSecondResponseModel({
    this.token,
    this.error,
    this.CI,
  });
  factory RegisterSecondResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterSecondResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
      CI: json["Customer-ID"] != null ? json["Customer-ID"] : "",
    );
  }
}

class RegisterSecondRequestModel {
  String phone;
  String otp;

  RegisterSecondRequestModel({this.phone, this.otp});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone,
      'OTP': otp,
    };
    return map;
  }
}
