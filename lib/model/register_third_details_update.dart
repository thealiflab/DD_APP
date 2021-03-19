class RegisterThirdResponseModel {
  final String message;

  RegisterThirdResponseModel({
    this.message,
  });
  factory RegisterThirdResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterThirdResponseModel(
      message: json["message"] != null ? json["message"] : "",
    );
  }
}

class RegisterThirdRequestModel {
  String name;
  String email;
  String password;

  RegisterThirdRequestModel({this.name, this.email});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'email': email,
      'password': password,
    };
    return map;
  }
}
