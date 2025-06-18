// To parse this JSON data, do
//
//     final getOrderRecipientIdModel = getOrderRecipientIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:delivery_man_app/TrydosChat/data/models/my_chats_response_model.dart';

GetOrderRecipientIdModel getOrderRecipientIdModelFromJson(String str) =>
    GetOrderRecipientIdModel.fromJson(json.decode(str));

String getOrderRecipientIdModelToJson(GetOrderRecipientIdModel data) =>
    json.encode(data.toJson());

class GetOrderRecipientIdModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;
  final Data? data;

  GetOrderRecipientIdModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  GetOrderRecipientIdModel copyWith({
    bool? isSuccessful,
    bool? hasContent,
    int? code,
    dynamic message,
    dynamic detailedError,
    Data? data,
  }) =>
      GetOrderRecipientIdModel(
        isSuccessful: isSuccessful ?? this.isSuccessful,
        hasContent: hasContent ?? this.hasContent,
        code: code ?? this.code,
        message: message ?? this.message,
        detailedError: detailedError ?? this.detailedError,
        data: data ?? this.data,
      );

  factory GetOrderRecipientIdModel.fromJson(Map<String, dynamic> json) =>
      GetOrderRecipientIdModel(
        isSuccessful: json["isSuccessful"],
        hasContent: json["hasContent"],
        code: json["code"],
        message: json["message"],
        detailedError: json["detailed_error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccessful": isSuccessful,
        "hasContent": hasContent,
        "code": code,
        "message": message,
        "detailed_error": detailedError,
        "data": data?.toJson(),
      };
}

class Data {
  final Recipient? recipient;
  final Chat? chatParticipant;

  Data({
    this.recipient,
    this.chatParticipant,
  });

  Data copyWith({
    Recipient? recipient,
    Chat? chatParticipant,
  }) =>
      Data(
        recipient: recipient ?? this.recipient,
        chatParticipant: chatParticipant ?? this.chatParticipant,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recipient: json["recipient"] == null
            ? null
            : Recipient.fromJson(json["recipient"]),
        chatParticipant:
            json["channel"] == null ? null : Chat.fromJson(json["channel"]),
      );

  Map<String, dynamic> toJson() => {
        "recipient": recipient?.toJson(),
        "channel": chatParticipant?.toJson(),
      };
}

class Recipient {
  final int? id;

  Recipient({
    this.id,
  });

  Recipient copyWith({
    int? id,
  }) =>
      Recipient(
        id: id ?? this.id,
      );

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
