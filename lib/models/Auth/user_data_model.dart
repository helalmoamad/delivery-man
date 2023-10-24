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

  Map<String, dynamic> toJson() => {
        "isSuccessful": isSuccessful,
        "hasContent": hasContent,
        "code": code,
        "message": message,
        "detailed_error": detailedError,
        "data": data?.toJson(),
      };
}

class UserDataModel {
  final int? id;
  final String? mobilePhone;
  final String? username;
  final String? name;
  final dynamic photoPath;
  final String? email;
  final dynamic assignToUserId;
  final String? accessToken;
  final dynamic assignedVehicle;

  UserDataModel({
    this.id,
    this.mobilePhone,
    this.username,
    this.name,
    this.photoPath,
    this.email,
    this.assignToUserId,
    this.accessToken,
    this.assignedVehicle,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        id: json["id"],
        mobilePhone: json["mobile_phone"],
        username: json["username"],
        name: json["name"],
        photoPath: json["photo_path"],
        email: json["email"],
        assignToUserId: json["assign_to_user_id"],
        accessToken: json["access_token"],
        assignedVehicle: json["assigned_vehicle"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobile_phone": mobilePhone,
        "username": username,
        "name": name,
        "photo_path": photoPath,
        "email": email,
        "assign_to_user_id": assignToUserId,
        "access_token": accessToken,
        "assigned_vehicle": assignedVehicle,
      };
}
