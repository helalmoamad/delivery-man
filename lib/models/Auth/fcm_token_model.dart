class SetFcmTokenModel {
  bool? isSuccessful;
  bool? hasContent;
  int? code;
  String? message;
  String? detailedError;
  SetFcmTokenDataModel? data;

  SetFcmTokenModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory SetFcmTokenModel.fromJson(Map<String, dynamic> json) =>
      SetFcmTokenModel(
        isSuccessful: json["isSuccessful"] ?? false,
        hasContent: json["hasContent"] ?? false,
        code: json["code"] ?? 400,
        message: json["message"] ?? '',
        detailedError: json["detailed_error"] ?? '',
        data: json["data"] == null
            ? null
            : SetFcmTokenDataModel.fromJson(json["data"]),
      );
}

class SetFcmTokenDataModel {
  int? userId;
  String? fcmToken;
  String? authToken;
  String? updatedAt;
  int? id;

  SetFcmTokenDataModel({
    this.userId,
    this.fcmToken,
    this.authToken,
    this.updatedAt,
    this.id,
  });

  factory SetFcmTokenDataModel.fromJson(Map<String, dynamic> json) =>
      SetFcmTokenDataModel(
        userId: json["user_id"],
        fcmToken: json["fcm_token"] ?? '',
        authToken: json["auth_token"] ?? '',
        updatedAt: json["updated_at"] ?? '',
        id: json["id"],
      );
}
