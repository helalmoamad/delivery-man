class ChangeStatusModle {
  final int? id;
  final int? journeyId;
  final int? assignToUserId;
  final int? customerId;
  final String? paymentStatus;
  final int? orderStatusId;
  final String? paymentMethod;
  final dynamic transactionRef;
  final int? orderAmount;
  final String? orderAmountFormatted;
  final dynamic shippingAddressId;
  final String? orderGroupId;
  final String? verificationCode;
  final String? sellerId;
  final List<Detail>? details;
  final int? shippingAddress;
  final ShippingAddressData? shippingAddressData;
  final dynamic billingAddress;
  final dynamic billingAddressData;
  final dynamic receivedAmount;
  final String? orderStatus;
  final List<dynamic>? orderFiles;
  final dynamic lastOrderFile;

  ChangeStatusModle({
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
    this.details,
    this.shippingAddress,
    this.shippingAddressData,
    this.billingAddress,
    this.billingAddressData,
    this.receivedAmount,
    this.orderStatus,
    this.orderFiles,
    this.lastOrderFile,
  });

  factory ChangeStatusModle.fromJson(Map<String, dynamic> json) =>
      ChangeStatusModle(
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
        details: json["details"] == null
            ? []
            : List<Detail>.from(
                json["details"]!.map((x) => Detail.fromJson(x))),
        shippingAddress: json["shipping_address"],
        shippingAddressData: json["shipping_address_data"] == null
            ? null
            : ShippingAddressData.fromJson(json["shipping_address_data"]),
        billingAddress: json["billing_address"],
        billingAddressData: json["billing_address_data"],
        receivedAmount: json["received_amount"],
        orderStatus: json["order_status"],
        orderFiles: json["order_files"] == null
            ? []
            : List<dynamic>.from(json["order_files"]!.map((x) => x)),
        lastOrderFile: json["last_order_file"],
      );
}

class Detail {
  final int? id;
  final int? qty;
  final int? tax;
  final String? price;
  final int? odooId;
  final String? variant;
  final String? discount;
  final int? orderId;
  final int? productId;
  final String? discountType;
  final int? odooOrderId;
  final String? paymentStatus;
  final int? refundRequest;
  final String? deliveryStatus;
  final int? isOdooProduct;
  final ProductDetails? productDetails;
  final int? isStockDecreased;
  final dynamic shippingMethodId;
  final String? priceAfterDiscount;
  final dynamic refundRequestStatus;

  Detail({
    this.id,
    this.qty,
    this.tax,
    this.price,
    this.odooId,
    this.variant,
    this.discount,
    this.orderId,
    this.productId,
    this.discountType,
    this.odooOrderId,
    this.paymentStatus,
    this.refundRequest,
    this.deliveryStatus,
    this.isOdooProduct,
    this.productDetails,
    this.isStockDecreased,
    this.shippingMethodId,
    this.priceAfterDiscount,
    this.refundRequestStatus,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        qty: json["qty"],
        tax: json["tax"],
        price: json["price"],
        odooId: json["odoo_id"],
        variant: json["variant"],
        discount: json["discount"],
        orderId: json["order_id"],
        productId: json["product_id"],
        discountType: json["discount_type"],
        odooOrderId: json["odoo_order_id"],
        paymentStatus: json["payment_status"],
        refundRequest: json["refund_request"],
        deliveryStatus: json["delivery_status"],
        isOdooProduct: json["is_odoo_product"],
        productDetails: json["product_details"] == null
            ? null
            : ProductDetails.fromJson(json["product_details"]),
        isStockDecreased: json["is_stock_decreased"],
        shippingMethodId: json["shipping_method_id"],
        priceAfterDiscount: json["price_after_discount"],
        refundRequestStatus: json["refund_request_status"],
      );
}

class ProductDetails {
  final int? id;
  final String? name;
  final String? slug;
  final double? price;
  final List<String>? images;
  final Rating? rating;
  final String? details;
  final bool? inStock;
  final String? thumbnail;
  final String? shareLink;
  final int? offerPrice;
  final bool? isFavourite;
  final String? priceFormatted;
  final String? offerPriceFormatted;

  ProductDetails({
    this.id,
    this.name,
    this.slug,
    this.price,
    this.images,
    this.rating,
    this.details,
    this.inStock,
    this.thumbnail,
    this.shareLink,
    this.offerPrice,
    this.isFavourite,
    this.priceFormatted,
    this.offerPriceFormatted,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        price: json["price"]?.toDouble(),
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
        details: json["details"],
        inStock: json["in_stock"],
        thumbnail: json["thumbnail"],
        shareLink: json["share_link"],
        offerPrice: json["offer_price"],
        isFavourite: json["is_favourite"],
        priceFormatted: json["price_formatted"],
        offerPriceFormatted: json["offer_price_formatted"],
      );
}

class Rating {
  final int? totalRating;
  final int? overallRating;

  Rating({
    this.totalRating,
    this.overallRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        totalRating: json["total_rating"],
        overallRating: json["overall_rating"],
      );

  Map<String, dynamic> toJson() => {
        "total_rating": totalRating,
        "overall_rating": overallRating,
      };
}

class ShippingAddressData {
  final int? id;
  final dynamic zip;
  final String? city;
  final String? cost;
  final String? email;
  final String? phone;
  final dynamic state;
  final String? address;
  final String? country;
  final dynamic duration;
  final dynamic latitude;
  final dynamic longitude;
  final DateTime? createdAt;
  final int? isBilling;
  final int? isDefault;
  final DateTime? updatedAt;
  final int? customerId;
  final String? addressType;
  final String? contactPersonName;

  ShippingAddressData({
    this.id,
    this.zip,
    this.city,
    this.cost,
    this.email,
    this.phone,
    this.state,
    this.address,
    this.country,
    this.duration,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.isBilling,
    this.isDefault,
    this.updatedAt,
    this.customerId,
    this.addressType,
    this.contactPersonName,
  });

  factory ShippingAddressData.fromJson(Map<String, dynamic> json) =>
      ShippingAddressData(
        id: json["id"],
        zip: json["zip"],
        city: json["city"],
        cost: json["cost"],
        email: json["email"],
        phone: json["phone"],
        state: json["state"],
        address: json["address"],
        country: json["country"],
        duration: json["duration"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isBilling: json["is_billing"],
        isDefault: json["is_default"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customerId: json["customer_id"],
        addressType: json["address_type"],
        contactPersonName: json["contact_person_name"],
      );
}
