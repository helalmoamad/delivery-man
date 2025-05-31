class ChatLoginModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final String? message;
  final String? detailedError;
  final ChatLoginDataModel? data;

  ChatLoginModel({
    required this.isSuccessful,
    required this.hasContent,
    required this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory ChatLoginModel.fromJson(Map<String, dynamic> json) {
    return ChatLoginModel(
      isSuccessful: json['isSuccessful'] ?? false,
      hasContent: json['hasContent'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'],
      detailedError: json['detailed_error'],
      data: json['data'] != null
          ? ChatLoginDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class ChatLoginDataModel {
  final int? id;
  final String? name;
  final String? username;
  final String? mobilePhone;
  final String? photoPath;
  final String? createdAt;
  final String? accessToken;
  final String? contactUser;

  ChatLoginDataModel({
    required this.id,
    required this.name,
    this.username,
    required this.mobilePhone,
    this.photoPath,
    required this.createdAt,
    required this.accessToken,
    this.contactUser,
  });

  factory ChatLoginDataModel.fromJson(Map<String, dynamic> json) {
    return ChatLoginDataModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      mobilePhone: json['mobile_phone'],
      photoPath: json['photo_path'],
      createdAt: json['created_at'],
      accessToken: json['access_token'],
      contactUser: json['contact_user'],
    );
  }
}
