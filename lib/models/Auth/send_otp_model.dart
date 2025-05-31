class SendOtpResponseModel {
  final bool isSuccessful;
  final bool hasContent;
  final int code;
  final String message;
  final String? detailedError;
  final SendOtpDataModel? data;

  SendOtpResponseModel({
    required this.isSuccessful,
    required this.hasContent,
    required this.code,
    required this.message,
    this.detailedError,
    this.data,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SendOtpResponseModel(
      isSuccessful: json['isSuccessful'],
      hasContent: json['hasContent'],
      code: json['code'],
      message: json['message'],
      detailedError: json['detailed_error'],
      data:
          json['data'] != null ? SendOtpDataModel.fromJson(json['data']) : null,
    );
  }
}

class SendOtpDataModel {
  final String verificationId;

  SendOtpDataModel({required this.verificationId});

  factory SendOtpDataModel.fromJson(Map<String, dynamic> json) {
    return SendOtpDataModel(
      verificationId: json['verificationId'],
    );
  }
}
