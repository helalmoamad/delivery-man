class AssignToVehicleModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;
  final Data? data;

  AssignToVehicleModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory AssignToVehicleModel.fromJson(Map<String, dynamic> json) =>
      AssignToVehicleModel(
        isSuccessful: json["isSuccessful"],
        hasContent: json["hasContent"],
        code: json["code"],
        message: json["message"] ?? '',
        detailedError: json["detailed_error"] ?? '',
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final int? id;
  final DateTime? startedAt;
  final dynamic finishedAt;
  final int? assignedToUserId;
  final int? isFinished;
  final int? vehicleId;

  Data({
    this.id,
    this.startedAt,
    this.finishedAt,
    this.assignedToUserId,
    this.isFinished,
    this.vehicleId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        startedAt: json["started_at"] == null
            ? null
            : DateTime.parse(json["started_at"]),
        finishedAt: json["finished_at"] ?? '',
        assignedToUserId: json["assigned_to_user_id"],
        isFinished: json["is_finished"],
        vehicleId: json["vehicle_id"],
      );
}
