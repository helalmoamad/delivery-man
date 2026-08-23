// class SendOtpResponseModel {
//   final bool isSuccessful;
//   final bool hasContent;
//   final int code;
//   final String message;
//   final String? detailedError;
//   final SendOtpDataModel? data;

//   SendOtpResponseModel({
//     required this.isSuccessful,
//     required this.hasContent,
//     required this.code,
//     required this.message,
//     this.detailedError,
//     this.data,
//   });

//   factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
//     return SendOtpResponseModel(
//       isSuccessful: json['isSuccessful'],
//       hasContent: json['hasContent'],
//       code: json['code'],
//       message: json['message'],
//       detailedError: json['detailed_error'],
//       data:
//           json['data'] != null ? SendOtpDataModel.fromJson(json['data']) : null,
//     );
//   }
// }

// class SendOtpDataModel {
//   final String verificationId;

//   SendOtpDataModel({required this.verificationId});

//   factory SendOtpDataModel.fromJson(Map<String, dynamic> json) {
//     return SendOtpDataModel(
//       verificationId: json['verificationId'],
//     );
//   }
// }
class OtpResponse {
  final String message;
  final String otpId;

  OtpResponse({
    required this.message,
    required this.otpId,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'] ?? '',
      otpId: json['otp_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'otp_id': otpId,
    };
  }
}
