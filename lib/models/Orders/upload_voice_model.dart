import '../json_serializable.dart';

class UploadVoiceModel extends JsonSerializable {
  final int orderId;
  final String filePath;

  UploadVoiceModel({
    required this.orderId,
    required this.filePath,
  });

  factory UploadVoiceModel.fromJson(Map<String, dynamic> json) =>
      UploadVoiceModel(
        orderId: json["order_id"],
        filePath: json["file_path"],
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'file_path': filePath,
    };
  }
}
