class CustomerResponseModel {
  final String name;

  CustomerResponseModel({
    this.name,
  });
  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      name: json["name"] != null ? json["name"] : "",
    );
  }
}
