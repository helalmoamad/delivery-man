class AssignOrderToMeDataModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final dynamic message;
  final dynamic detailedError;
  final Data? data;

  AssignOrderToMeDataModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory AssignOrderToMeDataModel.fromJson(Map<String, dynamic> json) =>
      AssignOrderToMeDataModel(
        isSuccessful: json["isSuccessful"],
        hasContent: json["hasContent"],
        code: json["code"],
        message: json["message"],
        detailedError: json["detailed_error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  final int? id;
  final int? journeyId;
  final int? assignToUserId;
  final int? customerId;
  final String? paymentStatus;
  final int? orderStatusId;
  final String? paymentMethod;
  final String? transactionRef;
  final int? orderAmount;
  final String? orderAmountFormatted;
  final int? shippingAddressId;
  final String? orderGroupId;
  final String? verificationCode;
  final String? sellerId;
  final String? orderStatus;

  Data({
    this.id,
    this.journeyId,
    this.assignToUserId,
    this.customerId,
    this.paymentStatus,
    this.orderStatusId,
    this.paymentMethod,
    this.transactionRef,
    this.orderAmount,
    this.orderAmountFormatted,
    this.shippingAddressId,
    this.orderGroupId,
    this.verificationCode,
    this.sellerId,
    this.orderStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        journeyId: json["journey_id"],
        assignToUserId: json["assign_to_user_id"],
        customerId: json["customer_id"],
        paymentStatus: json["payment_status"],
        orderStatusId: json["order_status_id"],
        paymentMethod: json["payment_method"],
        transactionRef: json["transaction_ref"],
        orderAmount: json["order_amount"],
        orderAmountFormatted: json["order_amount_formatted"],
        shippingAddressId: json["shipping_address_id"],
        orderGroupId: json["order_group_id"],
        verificationCode: json["verification_code"],
        sellerId: json["seller_id"],
        orderStatus: json["order_status"],
      );
}
