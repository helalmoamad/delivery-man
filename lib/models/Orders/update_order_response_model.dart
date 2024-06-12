import 'package:delivery_man_app/models/Orders/list_order_model.dart';

class UpdateOrderResponseModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final String? message;
  final dynamic detailedError;
  final OrderDataModel? data;

  UpdateOrderResponseModel({
    required this.isSuccessful,
    required this.hasContent,
    required this.code,
    required this.message,
    required this.detailedError,
    required this.data,
  });

  factory UpdateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateOrderResponseModel(
        isSuccessful: json["isSuccessful"] ?? false,
        hasContent: json["hasContent"] ?? false,
        code: json["code"] ?? 400,
        message: json["message"] ?? '',
        detailedError: json["detailed_error"] ?? '',
        data:
            json["data"] == null ? null : OrderDataModel.fromJson(json["data"]),
      );
}
