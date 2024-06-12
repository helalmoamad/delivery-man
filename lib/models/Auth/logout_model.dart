class LogOutModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;

  LogOutModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
  });

  factory LogOutModel.fromJson(Map<String, dynamic> json) => LogOutModel(
        isSuccessful: json["isSuccessful"] ?? false,
        hasContent: json["hasContent"] ?? false,
        code: json["code"] ?? 400,
        message: json["message"] ?? '',
        detailedError: json["detailed_error"] ?? '',
      );
}
