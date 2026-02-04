class MyOrdersResponse {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final String? message;
  final dynamic detailedError;
  final List<OrderModel1>? data;

  MyOrdersResponse({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    required this.data,
  });

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) {
    return MyOrdersResponse(
      isSuccessful: json["isSuccessful"],
      hasContent: json["hasContent"],
      code: json["code"],
      message: json["message"],
      detailedError: json["detailed_error"],
      data: json["data"] == null
          ? []
          : List<OrderModel1>.from(
              json["data"].map((x) => OrderModel1.fromJson(x))),
    );
  }
}

class OrderModel1 {
  final int? id;
  final int? journeyId;
  final int? assignToUserId;
  final int? customerId;
  final dynamic paymentStatus;
  final dynamic paymentMethod;
  final dynamic transactionRef;
  final dynamic orderAmount;
  final dynamic exchangeRate;
  final dynamic currencyCode;
  final dynamic currencySymbol;
  final String? orderStatus;
  final String? createdAt;
  final int? orderStatusId;
  final double? weight;
  final double? vWeight;
  final int? productsCount;
  final String? shipmentNumber;
  final int? originalOrderId;
  final int? parentOrderId;
  final List<ProductModel1>? details;
  final List<ProductModel1>? detailsWithLocalPrices;
  final ShippingAddressData1? shippingAddressData;
  final double? codAmount;
  final String? codAmountLocalFormatted;
  final double? codAmountLocal;
  final double? orderAmountLocal;
  final String? orderAmountLocalFormatted;
  final String? orderGroupId;
  final String? verificationCode;
  final String? sellerId;
  final dynamic type;
  final int? isPaymentDone;
  final List<dynamic>? lastOrderFile;
  final dynamic currentLocation;

  OrderModel1({
    required this.id,
    required this.journeyId,
    required this.assignToUserId,
    required this.customerId,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.transactionRef,
    required this.orderAmount,
    required this.exchangeRate,
    required this.currencyCode,
    required this.currencySymbol,
    required this.orderStatus,
    required this.createdAt,
    this.orderStatusId,
    this.weight,
    this.vWeight,
    this.productsCount,
    this.shipmentNumber,
    this.originalOrderId,
    this.parentOrderId,
    required this.details,
    this.detailsWithLocalPrices,
    this.shippingAddressData,
    this.codAmount,
    this.codAmountLocalFormatted,
    this.codAmountLocal,
    this.orderAmountLocal,
    this.orderAmountLocalFormatted,
    this.orderGroupId,
    this.verificationCode,
    this.sellerId,
    this.type,
    this.isPaymentDone,
    this.lastOrderFile,
    this.currentLocation,
  });

  factory OrderModel1.fromJson(Map<String, dynamic> json) => OrderModel1(
        id: json["id"],
        journeyId: json["journey_id"],
        assignToUserId: json["assign_to_user_id"],
        customerId: json["customer_id"],
        paymentStatus: json["payment_status"],
        paymentMethod: json["payment_method"],
        transactionRef: json["transaction_ref"],
        orderAmount: json["order_amount"],
        exchangeRate: json["exchange_rate"],
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
        orderStatus: json["order_status"],
        createdAt: json["created_at"],
        orderStatusId: json["order_status_id"],
        weight: (json["weight"] ?? 0).toDouble(),
        vWeight: (json["v_weight"] ?? 0).toDouble(),
        productsCount: json["products_count"],
        shipmentNumber: json["ShipmentNumber"] ?? json["shipment_number"],
        originalOrderId: json["original_order_id"],
        parentOrderId: json["parent_order_id"],
        details: json["details"] == null
            ? []
            : List<ProductModel1>.from(
                json["details"].map((x) => ProductModel1.fromJson(x))),
        detailsWithLocalPrices: json["details_with_local_prices"] == null
            ? []
            : List<ProductModel1>.from(
                json["details_with_local_prices"]
                    .map((x) => ProductModel1.fromJson(x))),
       shippingAddressData: (json["shipping_address_data"] != null && json["shipping_address_data"] is Map<String, dynamic>)
    ? ShippingAddressData1.fromJson(json["shipping_address_data"])
    : null,
        codAmount: (json["CODAmount"] ?? 0).toDouble(),
        codAmountLocalFormatted: json["cod_amount_local_formatted"],
        codAmountLocal: (json["cod_amount_local"] ?? 0).toDouble(),
        orderAmountLocal: (json["order_amount_local"] ?? 0).toDouble(),
        orderAmountLocalFormatted: json["order_amount_local_formatted"],
        orderGroupId: json["order_group_id"],
        verificationCode: json["verification_code"],
        sellerId: json["seller_id"],
        type: json["type"],
        isPaymentDone: json["is_payment_done"],
        lastOrderFile: json["last_order_file"] ?? [],
        currentLocation: json["current_location"],
      );
}

class ProductModel1 {
  final int? id;
  final int? qty;
  final dynamic price;
  final dynamic discount;
  final dynamic variant;
  final ProductDetails1? productDetails;
  final bool? isStockDecreased;
  final String? deliveryStatus;

  ProductModel1({
    required this.id,
    required this.qty,
    required this.price,
    required this.discount,
    required this.variant,
    required this.productDetails,
    this.isStockDecreased,
    this.deliveryStatus,
  });

  factory ProductModel1.fromJson(Map<String, dynamic> json) => ProductModel1(
        id: json["id"],
        qty: json["qty"],
        price: json["price"],
        discount: json["discount"],
        variant: json["variant"],
isStockDecreased: json["is_stock_decreased"] != null && json["is_stock_decreased"] == 1,
        deliveryStatus: json["delivery_status"],
        productDetails: json["product_details"] == null
            ? null
            : ProductDetails1.fromJson(json["product_details"]),
      );
}

class ProductDetails1 {
  final int? id;
  final String? name;
  final String? slug;
  final dynamic price;
  final String? image;
  final dynamic offerPrice;
  final bool? inStock;
  final String? shareLink;

  ProductDetails1({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.image,
    required this.offerPrice,
    required this.inStock,
    this.shareLink,
  });

  factory ProductDetails1.fromJson(Map<String, dynamic> json) => ProductDetails1(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        price: json["price"],
        image: json["image"],
        offerPrice: json["offer_price"],
        inStock: json["in_stock"],
        shareLink: json["share_link"],
      );
}

class ShippingAddressData1 {
  final String? zip;
  final String? city;
  final String? town;
  final String? address;
  final String? street;
  final String? building;
  final String? latitude;
  final String? longitude;
  final String? province;
  final String? phone;
  final String? alternativePhone;
  final String? contactPersonName;

  ShippingAddressData1({
    this.zip,
    this.city,
    this.town,
    this.address,
    this.street,
    this.building,
    this.latitude,
    this.longitude,
    this.province,
    this.phone,
    this.alternativePhone,
    this.contactPersonName,
  });

  factory ShippingAddressData1.fromJson(Map<String, dynamic> json) =>
      ShippingAddressData1(
        zip: json["zip"],
        city: json["city"],
        town: json["town"],
        address: json["address"],
        street: json["street"],
        building: json["building"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        province: json["province"],
        phone: json["phone"],
        alternativePhone: json["alternative_phone"],
        contactPersonName: json["contact_person_name"],
      );
}
