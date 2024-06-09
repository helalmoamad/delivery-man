class UnAssignToVehicleModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;
  final Data? data;

  UnAssignToVehicleModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory UnAssignToVehicleModel.fromJson(Map<String, dynamic> json) =>
      UnAssignToVehicleModel(
        isSuccessful: json["isSuccessful"] ?? false,
        hasContent: json["hasContent"] ?? false,
        code: json["code"] ?? 400,
        message: json["message"] ?? '',
        detailedError: json["detailed_error"] ?? '',
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final int? id;
  final String? mobilePhone;
  final String? username;
  final String? name;
  final dynamic photoPath;
  final String? email;
  final int? assignToUserId;
  final dynamic assignedVehicle;
  final dynamic currentJourney;

  Data({
    this.id,
    this.mobilePhone,
    this.username,
    this.name,
    this.photoPath,
    this.email,
    this.assignToUserId,
    this.assignedVehicle,
    this.currentJourney,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        mobilePhone: json["mobile_phone"] ?? '',
        username: json["username"] ?? '',
        name: json["name"] ?? '',
        photoPath: json["photo_path"] ?? '',
        email: json["email"] ?? '',
        assignToUserId: json["assign_to_user_id"],
        assignedVehicle: json["assigned_vehicle"],
        currentJourney: json["current_journey"],
      );
}
