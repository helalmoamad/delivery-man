class VerifyOtpResponseModel {
  final bool isSuccessful;
  final bool hasContent;
  final int code;
  final String message;
  final String? detailedError;
  final VerifyOtpDataModel? data;

  VerifyOtpResponseModel({
    required this.isSuccessful,
    required this.hasContent,
    required this.code,
    required this.message,
    this.detailedError,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      isSuccessful: json['isSuccessful'],
      hasContent: json['hasContent'],
      code: json['code'],
      message: json['message'],
      detailedError: json['detailed_error'],
      data: json['data'] != null
          ? VerifyOtpDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccessful': isSuccessful,
      'hasContent': hasContent,
      'code': code,
      'message': message,
      'detailed_error': detailedError,
      'data': data?.toJson(),
    };
  }
}

class VerifyOtpDataModel {
  final String phone;
  final String idToken;

  VerifyOtpDataModel({
    required this.phone,
    required this.idToken,
  });

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpDataModel(
      phone: json['phone'],
      idToken: json['id_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'id_token': idToken,
    };
  }
}
