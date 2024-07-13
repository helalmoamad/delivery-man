import '../json_serializable.dart';

class UploadVoiceModel extends JsonSerializable {
  final int orderId;
  final String filePath;
  int numberOfUploadTry;

  UploadVoiceModel({
    required this.orderId,
    required this.filePath,
    required this.numberOfUploadTry,
  });

  factory UploadVoiceModel.fromJson(Map<String, dynamic> json) =>
      UploadVoiceModel(
        orderId: json["order_id"],
        filePath: json["file_path"],
        numberOfUploadTry: json["num_of_upload_try"],
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'file_path': filePath,
      'num_of_upload_try': numberOfUploadTry,
    };
  }
}
