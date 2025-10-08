import 'dart:convert';

class ErrorLog {
  final String flutterVersion;
  final String deviceInfo;
  final String? clientIp;
  final String errorType;
  final List<String>? lastFourPageVisited;
  final int? userChatId;
  final String? userChatName;
  final String? userChatPhoto;
  final String? userChatToken;
  final String? language;
  final String? urlBackend;
  final String? messageFromBackend;
  final String? lastApiRequest;
  final String? errorPath;
  final int? userFleetId;
  final String? userFleetName;
  final String? userFleetToken;
  final bool? isLoggedIn;
  final DateTime timestamp;

  ErrorLog({
    required this.flutterVersion,
    required this.deviceInfo,
    this.clientIp,
    required this.errorType,
    this.lastFourPageVisited,
    this.userChatId,
    this.userChatName,
    this.userChatPhoto,
    this.userChatToken,
    this.language,
    this.urlBackend,
    this.messageFromBackend,
    this.lastApiRequest,
    this.errorPath,
    DateTime? timestamp,
    this.isLoggedIn,
    this.userFleetId,
    this.userFleetName,
    this.userFleetToken,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'flutterVersion': flutterVersion,
      'deviceInfo': deviceInfo,
      'clientIp': clientIp,
      'errorType': errorType,
      'lastFourPageVisited': lastFourPageVisited,
      'userChatId': userChatId,
      'userChatName': userChatName,
      'userChatPhoto': userChatPhoto,
      'userChatToken': userChatToken,
      'language': language,
      'urlBackend': urlBackend,
      'messageFromBackend': messageFromBackend,
      'lastApiRequest': lastApiRequest,
      'errorPath': errorPath,
      'isLoggedIn': isLoggedIn,
      'userFleetId': userFleetId,
      'userFleetName': userFleetName,
      'userFleetToken': userFleetToken,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static ErrorLog fromJson(Map<String, dynamic> json) {
    return ErrorLog(
      flutterVersion: json['flutterVersion'],
      deviceInfo: json['deviceInfo'],
      clientIp: json['clientIp'],
      errorType: json['errorType'],
      lastFourPageVisited: json['lastFourPageVisited'] != null
          ? List<String>.from(json['lastFourPageVisited'])
          : null,
      userChatId: json['userChatId'],
      userChatName: json['userChatName'],
      userChatPhoto: json['userChatPhoto'],
      userChatToken: json['userChatToken'],
      language: json['language'],
      urlBackend: json['urlBackend'],
      messageFromBackend: json['messageFromBackend'],
      lastApiRequest: json['lastApiRequest'],
      errorPath: json['errorPath'],
      timestamp: DateTime.parse(json['timestamp']),
      isLoggedIn: json['isLoggedIn'],
      userFleetId: json['userFleetId'],
      userFleetName: json['userFleetName'],
      userFleetToken: json['userFleetToken'],
    );
  }
}
