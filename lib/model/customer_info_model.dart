class CustomerInfoGetModel {
  String id;
  String userUniqueId;
  String userFullname;
  String userPhone;
  String userProfileImage;
  String userEmail;
  String registrationDateTime;
  String userLastLogin;
  List<bool> subscriptionStatus;
  bool isRegistered;
  bool isSubscriptionExpired;
  String lastSubscriptionDate;
  String lastSubscriptionLimit;
  String lastSubscriptionExpireDate;
  List<SubscriptionHistory> subscriptionHistory;
  List<ClaimHistory> claimHistory;
  int unseenNotification;

  CustomerInfoGetModel(
      {this.id,
      this.userUniqueId,
      this.userFullname,
      this.userPhone,
      this.userProfileImage,
      this.userEmail,
      this.registrationDateTime,
      this.userLastLogin,
      this.subscriptionStatus,
      this.isRegistered,
      this.isSubscriptionExpired,
      this.lastSubscriptionDate,
      this.lastSubscriptionLimit,
      this.lastSubscriptionExpireDate,
      this.subscriptionHistory,
      this.claimHistory,
      this.unseenNotification});

  CustomerInfoGetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userUniqueId = json['user_unique_id'];
    userFullname = json['user_fullname'];
    userPhone = json['user_phone'];
    userProfileImage = json['user_profile_image'];
    userEmail = json['user_email'];
    registrationDateTime = json['registration_date_time'];
    userLastLogin = json['user_last_login'];
    subscriptionStatus = json['subscription_status'].cast<bool>();
    isRegistered = json['isRegistered'];
    isSubscriptionExpired = json['isSubscriptionExpired'];
    lastSubscriptionDate = json['lastSubscriptionDate'];
    lastSubscriptionLimit = json['lastSubscriptionLimit'];
    lastSubscriptionExpireDate = json['lastSubscriptionExpireDate'];
    if (json['subscriptionHistory'] != null) {
      subscriptionHistory = List<SubscriptionHistory>.empty(growable: true);
      json['subscriptionHistory'].forEach((v) {
        subscriptionHistory.add(new SubscriptionHistory.fromJson(v));
      });
    }
    if (json['claimHistory'] != null) {
      claimHistory = List<ClaimHistory>.empty(growable: true);
      json['claimHistory'].forEach((v) {
        claimHistory.add(new ClaimHistory.fromJson(v));
      });
    }
    unseenNotification = json["unseenNotification"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_unique_id'] = this.userUniqueId;
    data['user_fullname'] = this.userFullname;
    data['user_phone'] = this.userPhone;
    data['user_profile_image'] = this.userProfileImage;
    data['user_email'] = this.userEmail;
    data['registration_date_time'] = this.registrationDateTime;
    data['user_last_login'] = this.userLastLogin;
    data['subscription_status'] = this.subscriptionStatus;
    data['isRegistered'] = this.isRegistered;
    data['lastSubscriptionDate'] = this.lastSubscriptionDate;
    data['lastSubscriptionLimit'] = this.lastSubscriptionLimit;
    data['lastSubscriptionExpireDate'] = this.lastSubscriptionExpireDate;
    if (this.subscriptionHistory != null) {
      data['subscriptionHistory'] =
          this.subscriptionHistory.map((v) => v.toJson()).toList();
    }
    if (this.claimHistory != null) {
      data['claimHistory'] = this.claimHistory.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class SubscriptionHistory {
  String id;
  String userId;
  String subscriptionDateTime;
  String subscriptionLimit;
  String subscriptionExpireDateTime;
  String paymentAmount;
  String transactionId;
  String expired;

  SubscriptionHistory(
      {this.id,
      this.userId,
      this.subscriptionDateTime,
      this.subscriptionLimit,
      this.subscriptionExpireDateTime,
      this.paymentAmount,
      this.transactionId,
      this.expired});

  SubscriptionHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subscriptionDateTime = json['subscription_date_time'];
    subscriptionLimit = json['subscription_limit'];
    subscriptionExpireDateTime = json['subscription_expire_date_time'];
    paymentAmount = json['payment_amount'];
    transactionId = json['transaction_id'];
    expired = json['expired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['subscription_date_time'] = this.subscriptionDateTime;
    data['subscription_limit'] = this.subscriptionLimit;
    data['subscription_expire_date_time'] = this.subscriptionExpireDateTime;
    data['payment_amount'] = this.paymentAmount;
    data['transaction_id'] = this.transactionId;
    data['expired'] = this.expired;
    return data;
  }
}

class ClaimHistory {
  String claimId;
  String userId;
  String vendorId;
  String vendorName;
  String vendorUniqueId;
  String locationName;
  String discountAmount;
  String claimVia;
  String dateTime;
  String accepted;

  ClaimHistory(
      {this.claimId,
      this.userId,
      this.vendorId,
      this.vendorName,
      this.vendorUniqueId,
      this.locationName,
      this.discountAmount,
      this.claimVia,
      this.dateTime,
      this.accepted});

  ClaimHistory.fromJson(Map<String, dynamic> json) {
    claimId = json['claim_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    vendorName = json['vendor_name'];
    vendorUniqueId = json['vendor_unique_id'];
    locationName = json['location_name'];
    discountAmount = json['discount_amount'];
    claimVia = json['claim_via'];
    dateTime = json['date_time'];
    accepted = json['accepted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['claim_id'] = this.claimId;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['vendor_name'] = this.vendorName;
    data['vendor_unique_id'] = this.vendorUniqueId;
    data['location_name'] = this.locationName;
    data['discount_amount'] = this.discountAmount;
    data['claim_via'] = this.claimVia;
    data['date_time'] = this.dateTime;
    data['accepted'] = this.accepted;
    return data;
  }
}
