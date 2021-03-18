class RegisterFirstResponseModel {
  final String message;
  final bool status;
  final String error;

  RegisterFirstResponseModel({
    this.message,
    this.status,
    this.error,
  });
  factory RegisterFirstResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterFirstResponseModel(
      message: json["message"] != null ? json["message"] : "",
      status: json["status"] != null ? json["status"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class RegisterFirstRequestModel {
  String phone;

  RegisterFirstRequestModel({
    this.phone,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'phone': phone.trim(),
    };
    return map;
  }
}
