class ListOrderModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final dynamic code;
  final dynamic message;
  final dynamic detailedError;
  final ListOrderDataModel? data;

  ListOrderModel({
    this.isSuccessful,
    this.hasContent,
    this.code,
    this.message,
    this.detailedError,
    required this.data,
  });

  factory ListOrderModel.fromJson(Map<String, dynamic> json) => ListOrderModel(
        isSuccessful: json["isSuccessful"],
        hasContent: json["hasContent"],
        code: json["code"],
        message: json["message"],
        detailedError: json["detailed_error"],
        data: json["data"] == null
            ? null
            : ListOrderDataModel.fromJson(json["data"]),
      );
}

class ListOrderDataModel {
  final dynamic currentPage;
  final List<OrderDataModel>? data;
  dynamic total;

  ListOrderDataModel({
    required this.currentPage,
    required this.data,
    required this.total,
  });

  factory ListOrderDataModel.fromJson(Map<String, dynamic> json) =>
      ListOrderDataModel(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<OrderDataModel>.from(
                json["data"]!.map((x) => OrderDataModel.fromJson(x))),
        total: json["total"],
      );
}

class OrderDataModel {
  final int? id;
  final int? originalOrderId;
  final dynamic journeyId;
  final dynamic assignToUserId;
  final dynamic customerId;
  dynamic paymentStatus;
  final dynamic orderStatusId;
  final dynamic paymentMethod;
  final dynamic transactionRef;
  dynamic orderAmount;
  dynamic orderAmountFormatted;
  final dynamic codAmount;
  final dynamic shippingAddressId;
  final dynamic orderGroupId;
  final dynamic verificationCode;
  final dynamic sellerId;
  final List<ProductModel>? products;
  final List<ProductModel>? returnedProducts;
  final dynamic shippingAddress;
  final ShippingAddressData? shippingAddressData;
  final dynamic billingAddress;
  final dynamic billingAddressData;
  dynamic receivedAmount;
  final dynamic orderStatus;

  OrderDataModel({
    this.id,
    this.originalOrderId,
    required this.journeyId,
    required this.assignToUserId,
    required this.customerId,
    required this.paymentStatus,
    required this.orderStatusId,
    required this.paymentMethod,
    required this.transactionRef,
    required this.orderAmount,
    required this.orderAmountFormatted,
    required this.codAmount,
    required this.shippingAddressId,
    required this.orderGroupId,
    required this.verificationCode,
    required this.sellerId,
    required this.products,
    required this.returnedProducts,
    required this.shippingAddress,
    required this.shippingAddressData,
    required this.billingAddress,
    required this.billingAddressData,
    required this.orderStatus,
    required this.receivedAmount,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) => OrderDataModel(
        id: json["id"],
        originalOrderId: json["original_order_id"],
        journeyId: json["journey_id"] ?? '',
        assignToUserId: json["assign_to_user_id"] ?? '',
        customerId: json["customer_id"] ?? '',
        paymentStatus: json["payment_status"] ?? '',
        orderStatusId: json["order_status_id"] ?? '',
        paymentMethod: json["payment_method"] ?? '',
        transactionRef: json["transaction_ref"] ?? '',
        orderAmount: json["order_amount"] ?? '',
        orderAmountFormatted: json["order_amount_formatted"] ?? '',
        codAmount: json["CODAmount"] ?? '',
        shippingAddressId: json["shipping_address_id"] ?? '',
        orderGroupId: json["order_group_id"] ?? '',
        verificationCode: json["verification_code"] ?? '',
        sellerId: json["seller_id"] ?? '',
        products: json["details"] == null
            ? []
            : List<ProductModel>.from(
                json["details"]!.map((x) => ProductModel.fromJson(x))),
        returnedProducts: json["returned_products"] == null
            ? []
            : List<ProductModel>.from(
                json["details"]!.map((x) => ProductModel.fromJson(x))),
        shippingAddress: json["shipping_address"] ?? '',
        shippingAddressData: json["shipping_address_data"] == null
            ? null
            : ShippingAddressData.fromJson(json["shipping_address_data"]),
        billingAddress: json["billing_address"] ?? '',
        billingAddressData: json["billing_address_data"],
        orderStatus: json["order_status"] ?? '',
        receivedAmount: json["received_amount"] ?? '',
      );
}

class ProductModel {
  final int? id;
  final dynamic qty;
  final dynamic tax;
  final dynamic price;
  final dynamic odooId;
  final dynamic variant;
  final dynamic discount;
  final dynamic orderId;
  final dynamic productId;
  final dynamic discountType;
  final dynamic odooOrderId;
  final dynamic paymentStatus;
  final dynamic refundRequest;
  final dynamic deliveryStatus;
  final dynamic isOdooProduct;
  final OrderProductDetails? productDetails;
  final dynamic isStockDecreased;
  final dynamic shippingMethodId;
  final dynamic priceAfterDiscount;
  final dynamic refundRequestStatus;

  ProductModel({
    required this.id,
    required this.qty,
    required this.tax,
    required this.price,
    required this.odooId,
    required this.variant,
    required this.discount,
    required this.orderId,
    required this.productId,
    required this.discountType,
    required this.odooOrderId,
    required this.paymentStatus,
    required this.refundRequest,
    required this.deliveryStatus,
    required this.isOdooProduct,
    required this.productDetails,
    required this.isStockDecreased,
    required this.shippingMethodId,
    required this.priceAfterDiscount,
    required this.refundRequestStatus,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? '',
        qty: json["qty"] ?? '',
        tax: json["tax"] ?? '',
        price: json["price"] ?? '',
        odooId: json["odoo_id"] ?? '',
        variant: json["variant"] ?? '',
        discount: json["discount"] ?? '',
        orderId: json["order_id"] ?? '',
        productId: json["product_id"] ?? '',
        discountType: json["discount_type"] ?? '',
        odooOrderId: json["odoo_order_id"] ?? '',
        paymentStatus: json["payment_status"] ?? '',
        refundRequest: json["refund_request"] ?? '',
        deliveryStatus: json["delivery_status"] ?? '',
        isOdooProduct: json["is_odoo_product"],
        productDetails: json["product_details"] == null
            ? null
            : OrderProductDetails.fromJson(json["product_details"]),
        isStockDecreased: json["is_stock_decreased"] ?? '',
        shippingMethodId: json["shipping_method_id"] ?? '',
        priceAfterDiscount: json["price_after_discount"] ?? '',
        refundRequestStatus: json["refund_request_status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qty": qty,
        "tax": tax,
        "price": price,
        "odoo_id": odooId,
        "variant": variant,
        "discount": discount,
        "order_id": orderId,
        "product_id": productId,
        "discount_type": discountType,
        "odoo_order_id": odooOrderId,
        "payment_status": paymentStatus,
        "refund_request": refundRequest,
        "delivery_status": deliveryStatus,
        "is_odoo_product": isOdooProduct,
        "product_details": productDetails?.toJson(),
        "is_stock_decreased": isStockDecreased,
        "shipping_method_id": shippingMethodId,
        "price_after_discount": priceAfterDiscount,
        "refund_request_status": refundRequestStatus,
      };
}

class OrderProductDetails {
  final int? id;
  final dynamic name;
  final dynamic slug;
  final dynamic price;
  final List<String>? images;
  final Rating? rating;
  final dynamic details;
  final bool? inStock;
  final dynamic thumbnail;
  final dynamic shareLink;
  final dynamic offerPrice;
  final bool? isFavourite;
  final dynamic priceFormatted;
  final dynamic offerPriceFormatted;

  OrderProductDetails({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.images,
    required this.rating,
    required this.details,
    required this.inStock,
    required this.thumbnail,
    required this.shareLink,
    required this.offerPrice,
    required this.isFavourite,
    required this.priceFormatted,
    required this.offerPriceFormatted,
  });

  factory OrderProductDetails.fromJson(Map<String, dynamic> json) =>
      OrderProductDetails(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        slug: json["slug"] ?? '',
        price: json["price"]?.toDouble(),
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
        details: json["details"] ?? '',
        inStock: json["in_stock"] ?? '',
        thumbnail: json["thumbnail"] ?? '',
        shareLink: json["share_link"] ?? '',
        offerPrice: json["offer_price"] ?? '',
        isFavourite: json["is_favourite"] ?? '',
        priceFormatted: json["price_formatted"] ?? '',
        offerPriceFormatted: json["offer_price_formatted"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "price": price,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "rating": rating?.toJson(),
        "details": details,
        "in_stock": inStock,
        "thumbnail": thumbnail,
        "share_link": shareLink,
        "offer_price": offerPrice,
        "is_favourite": isFavourite,
        "price_formatted": priceFormatted,
        "offer_price_formatted": offerPriceFormatted,
      };
}

class Rating {
  final dynamic totalRating;
  final dynamic overallRating;

  Rating({
    required this.totalRating,
    required this.overallRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        totalRating: json["total_rating"] ?? '',
        overallRating: json["overall_rating"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "total_rating": totalRating,
        "overall_rating": overallRating,
      };
}

class ShippingAddressData {
  final int? id;
  final dynamic zip;
  final dynamic city;
  final dynamic cost;
  final dynamic email;
  final dynamic phone;
  final dynamic state;
  final dynamic address;
  final dynamic country;
  final dynamic duration;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic createdAt;
  final dynamic isBilling;
  final dynamic isDefault;
  final dynamic updatedAt;
  final dynamic customerId;
  final dynamic addressType;
  final dynamic contactPersonName;

  ShippingAddressData({
    required this.id,
    required this.zip,
    required this.city,
    required this.cost,
    required this.email,
    required this.phone,
    required this.state,
    required this.address,
    required this.country,
    required this.duration,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.isBilling,
    required this.isDefault,
    required this.updatedAt,
    required this.customerId,
    required this.addressType,
    required this.contactPersonName,
  });

  factory ShippingAddressData.fromJson(Map<String, dynamic> json) =>
      ShippingAddressData(
        id: json["id"] ?? 0,
        zip: json["zip"] ?? '',
        city: json["city"] ?? '',
        cost: json["cost"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        state: json["state"] ?? '',
        address: json["address"] ?? '',
        country: json["country"] ?? '',
        duration: json["duration"] ?? '',
        latitude: json["latitude"] ?? '',
        longitude: json["longitude"] ?? '',
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isBilling: json["is_billing"] ?? '',
        isDefault: json["is_default"] ?? '',
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customerId: json["customer_id"] ?? '',
        addressType: json["address_type"] ?? '',
        contactPersonName: json["contact_person_name"] ?? '',
      );
}
