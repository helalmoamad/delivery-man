class ListOrderModel {
  final String? message;
  final ListOrderDataModel? data;

  ListOrderModel({
    this.message,
    this.data,
  });

  factory ListOrderModel.fromJson(Map<String, dynamic> json) => ListOrderModel(
        message: json["message"],
        data: json["data"] == null
            ? null
            : ListOrderDataModel.fromJson(json["data"]),
      );
}

class ListOrderDataModel {
  int? total;
  dynamic limit;
  int? offset;
  final List<Order>? orders;

  ListOrderDataModel({
    this.total,
    this.limit,
    this.offset,
    this.orders,
  });

  factory ListOrderDataModel.fromJson(Map<String, dynamic> json) =>
      ListOrderDataModel(
        total: json["total"],
        limit: json["limit"],
        offset: json["offset"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
      );
}

class Order {
  final dynamic id;
  final dynamic customerId;
  final dynamic paymentStatus;
  final dynamic orderStatus;
  final dynamic paymentMethod;
  final dynamic transactionRef;
  final dynamic orderAmount;
  final dynamic orderAmountFormatted;
  final dynamic shippingAddress;
  final IngAddressData? shippingAddressData;
  final dynamic billingAddress;
  final IngAddressData? billingAddressData;
  final dynamic discountAmount;
  final dynamic discountAmountFormatted;
  final dynamic discountType;
  final dynamic couponCode;
  final dynamic shippingMethodId;
  final dynamic shippingCost;
  final dynamic shippingCostFormatted;
  final dynamic orderGroupId;
  final dynamic verificationCode;
  final dynamic orderNote;
  final dynamic sellerId;
  final DateTime? createdAt;
  final bool? orderCanReturn;
  final bool? orderHasReturnRequest;
  final dynamic returnRequestId;
  final bool? showReturnRequest;
  final bool? editReturnRequest;
  final bool? orderCanExchange;

  Order({
    this.id,
    this.customerId,
    this.paymentStatus,
    this.orderStatus,
    this.paymentMethod,
    this.transactionRef,
    this.orderAmount,
    this.orderAmountFormatted,
    this.shippingAddress,
    this.shippingAddressData,
    this.billingAddress,
    this.billingAddressData,
    this.discountAmount,
    this.discountAmountFormatted,
    this.discountType,
    this.couponCode,
    this.shippingMethodId,
    this.shippingCost,
    this.shippingCostFormatted,
    this.orderGroupId,
    this.verificationCode,
    this.orderNote,
    this.sellerId,
    this.createdAt,
    this.orderCanReturn,
    this.orderHasReturnRequest,
    this.returnRequestId,
    this.showReturnRequest,
    this.editReturnRequest,
    this.orderCanExchange,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer_id"],
        paymentStatus: json["payment_status"],
        orderStatus: json["order_status"],
        paymentMethod: json["payment_method"],
        transactionRef: json["transaction_ref"],
        orderAmount: json["order_amount"],
        orderAmountFormatted: json["order_amount_formatted"],
        shippingAddress: json["shipping_address"],
        shippingAddressData: json["shipping_address_data"] == null
            ? null
            : IngAddressData.fromJson(json["shipping_address_data"]),
        billingAddress: json["billing_address"],
        billingAddressData: json["billing_address_data"] == null
            ? null
            : IngAddressData.fromJson(json["billing_address_data"]),
        discountAmount: json["discount_amount"],
        discountAmountFormatted: json["discount_amount_formatted"],
        discountType: json["discount_type"],
        couponCode: json["coupon_code"],
        shippingMethodId: json["shipping_method_id"],
        shippingCost: json["shipping_cost"],
        shippingCostFormatted: json["shipping_cost_formatted"],
        orderGroupId: json["order_group_id"],
        verificationCode: json["verification_code"],
        orderNote: json["order_note"],
        sellerId: json["seller_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        orderCanReturn: json["order_can_return"],
        orderHasReturnRequest: json["order_has_return_request"],
        returnRequestId: json["return_request_id"],
        showReturnRequest: json["show_return_request"],
        editReturnRequest: json["edit_return_request"],
        orderCanExchange: json["order_can_exchange"],
      );
}

class IngAddressData {
  final dynamic id;
  final dynamic customerId;
  final dynamic contactPersonName;
  final dynamic addressType;
  final dynamic address;
  final dynamic city;
  final dynamic zip;
  final dynamic phone;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic state;
  final dynamic country;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic isBilling;
  final dynamic isDefault;
  final dynamic email;
  final dynamic cost;
  final dynamic duration;

  IngAddressData({
    this.id,
    this.customerId,
    this.contactPersonName,
    this.addressType,
    this.address,
    this.city,
    this.zip,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.isBilling,
    this.isDefault,
    this.email,
    this.cost,
    this.duration,
  });

  factory IngAddressData.fromJson(Map<String, dynamic> json) => IngAddressData(
        id: json["id"],
        customerId: json["customer_id"],
        contactPersonName: json["contact_person_name"],
        addressType: json["address_type"],
        address: json["address"],
        city: json["city"],
        zip: json["zip"],
        phone: json["phone"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        state: json["state"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        isBilling: json["is_billing"],
        isDefault: json["is_default"],
        email: json["email"],
        cost: json["cost"],
        duration: json["duration"],
      );
}
