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
