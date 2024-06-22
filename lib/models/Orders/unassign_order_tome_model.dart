import 'assign_order_tome_data_model.dart';

class UnAssignOrderToMeDataModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;
  final AssignUnAssignOrderDataModel? data;

  UnAssignOrderToMeDataModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory UnAssignOrderToMeDataModel.fromJson(Map<String, dynamic> json) =>
      UnAssignOrderToMeDataModel(
        isSuccessful: json["isSuccessful"],
        hasContent: json["hasContent"],
        code: json["code"],
        message: json["message"],
        detailedError: json["detailed_error"],
        data: json["data"] == null
            ? null
            : AssignUnAssignOrderDataModel.fromJson(json["data"]),
      );
}
