import '../json_serializable.dart';

class RequestInfoModel extends JsonSerializable {
  final String url, requestType, token, header, body, response;

  RequestInfoModel(
      {required this.url,
      required this.requestType,
      required this.token,
      required this.header,
      required this.body,
      required this.response});

  factory RequestInfoModel.fromJson(Map<String, dynamic> json) =>
      RequestInfoModel(
          url: json["url"],
          requestType: json["requestType"],
          token: json["token"],
          header: json["header"],
          body: json["body"],
          response: json["response"]);

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'requestType': requestType,
      'token': token,
      'header': header,
      'body': body,
      'response': response,
    };
  }
}
