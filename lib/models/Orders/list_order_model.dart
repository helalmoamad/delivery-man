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
  final List<Detail>? details;

  Order(
      {this.id,
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
      this.details});

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
        details: json["details"] == null
            ? []
            : List<Detail>.from(
                json["details"]!.map((x) => Detail.fromJson(x))),
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

class Detail {
  final int? id;
  final dynamic orderId;
  final dynamic productId;
  final ProductDetails? productDetails;
  final dynamic qty;
  final dynamic price;
  final dynamic tax;
  final dynamic discount;
  final dynamic priceAfterDiscount;
  final dynamic deliveryStatus;
  final dynamic paymentStatus;
  final dynamic shippingMethodId;
  final dynamic variant;
  final dynamic discountType;
  final dynamic isStockDecreased;
  final dynamic refundRequest;
  final dynamic refundRequestStatus;
  final dynamic isOdooProduct;
  final dynamic odooId;
  final dynamic odooOrderId;

  Detail({
    this.id,
    this.orderId,
    this.productId,
    this.productDetails,
    this.qty,
    this.price,
    this.tax,
    this.discount,
    this.priceAfterDiscount,
    this.deliveryStatus,
    this.paymentStatus,
    this.shippingMethodId,
    this.variant,
    this.discountType,
    this.isStockDecreased,
    this.refundRequest,
    this.refundRequestStatus,
    this.isOdooProduct,
    this.odooId,
    this.odooOrderId,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        productDetails: json["product_details"] == null
            ? null
            : ProductDetails.fromJson(json["product_details"]),
        qty: json["qty"],
        price: json["price"],
        tax: json["tax"],
        discount: json["discount"],
        priceAfterDiscount: json["price_after_discount"],
        deliveryStatus: json["delivery_status"],
        paymentStatus: json["payment_status"],
        shippingMethodId: json["shipping_method_id"],
        variant: json["variant"],
        discountType: json["discount_type"],
        isStockDecreased: json["is_stock_decreased"],
        refundRequest: json["refund_request"],
        refundRequestStatus: json["refund_request_status"],
        isOdooProduct: json["is_odoo_product"],
        odooId: json["odoo_id"],
        odooOrderId: json["odoo_order_id"],
      );
}

class ProductDetails {
  final int? id;
  final dynamic name;
  final dynamic slug;
  final dynamic shareLink;
  final dynamic details;
  final dynamic thumbnail;
  final List<String>? images;
  final dynamic price;
  final dynamic priceFormatted;
  final dynamic offerPrice;
  final dynamic offerPriceFormatted;
  final bool? isFavourite;
  final bool? inStock;
  final Rating? rating;

  ProductDetails({
    this.id,
    this.name,
    this.slug,
    this.shareLink,
    this.details,
    this.thumbnail,
    this.images,
    this.price,
    this.priceFormatted,
    this.offerPrice,
    this.offerPriceFormatted,
    this.isFavourite,
    this.inStock,
    this.rating,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        shareLink: json["share_link"],
        details: json["details"],
        thumbnail: json["thumbnail"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        price: json["price"],
        priceFormatted: json["price_formatted"],
        offerPrice: json["offer_price"],
        offerPriceFormatted: json["offer_price_formatted"],
        isFavourite: json["is_favourite"],
        inStock: json["in_stock"],
        rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
      );
}

class Rating {
  final dynamic overallRating;
  final dynamic totalRating;

  Rating({
    this.overallRating,
    this.totalRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        overallRating: json["overall_rating"],
        totalRating: json["total_rating"],
      );
}
