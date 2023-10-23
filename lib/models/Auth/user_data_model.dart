class UserModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;
  final UserDataModel? data;

  UserModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        isSuccessful: json["isSuccessful"],
        hasContent: json["hasContent"],
        code: json["code"],
        message: json["message"] ?? '',
        detailedError: json["detailed_error"] ?? '',
        data:
            json["data"] == null ? null : UserDataModel.fromJson(json["data"]),
      );
}

class UserDataModel {
  final int? id;
  final String? mobilePhone;
  final String? username;
  final String? name;
  final dynamic photoPath;
  final String? email;
  final int? assignToUserId;
  final String? accessToken;

  UserDataModel({
    this.id,
    this.mobilePhone,
    this.username,
    this.name,
    this.photoPath,
    this.email,
    this.assignToUserId,
    this.accessToken,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        id: json["id"],
        mobilePhone: json["mobile_phone"],
        username: json["username"],
        name: json["name"],
        photoPath: json["photo_path"] ?? '',
        email: json["email"],
        assignToUserId: json["assign_to_user_id"],
        accessToken: json["access_token"],
      );
}
